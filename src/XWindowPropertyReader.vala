using X;

public struct FrameExtents {
    int left;
    int right;
    int top;
    int bottom;
}

public class XWindowPropertyReader {
    unowned X.Display display;
    unowned X.Window window;
    unowned X.Atom atom;
    ExtraAtomTypes? extra_types;
    X.Atom actual_type;
    X.Atom resolved_type;
    int actual_format;
    ulong n_items;
    ulong bytes_after;
    unowned void* data = null;

    static GLib.HashTable<uint, string?> string_formatting_map = new GLib.HashTable<uint, string?> (GLib.direct_hash, GLib.direct_equal);

    static construct {
        string_formatting_map.insert((uint) X.XA_WINDOW, "0x%lx");
        string_formatting_map.insert((uint) X.XA_ATOM, "0x%lx");
        string_formatting_map.insert((uint) X.XA_PIXMAP, "0x%lx");
    }

    public static XWindowPropertyReader ? for_atom_name(X.Display display, X.Window window, string atom_name, ExtraAtomTypes? extra_types = null) {
        var atom = display.intern_atom(atom_name, true);
        if (atom == X.None) {
            return null;
        }

        var reader = new XWindowPropertyReader(display, window, atom, extra_types);
        return reader.is_valid() ? reader : null;
    }

    public XWindowPropertyReader(X.Display display, X.Window window, X.Atom atom, ExtraAtomTypes? extra_types = null) {
        this.display = display;
        this.window = window;
        this.atom = atom;
        this.extra_types = extra_types;
        var status = display.get_window_property(window, atom, 0, 500000, false,
                                                 X.ANY_PROPERTY_TYPE, out actual_type,
                                                 out actual_format,
                                                 out n_items, out bytes_after, out data);

        resolved_type = extra_types == null
            ? actual_type : extra_types.get(actual_type) ?? actual_type;

        if (status != X.ErrorCode.SUCCESS) {
            return;
        }

        /*
           stdout.printf("Got window property [%s]: size=(%lu * %ld = %lu) type=%ld[%s] "
         + "resolved_type=%ld[%s]\n",
                      get_name(),
                      n_items, actual_format, n_items * actual_format,
                      (long) actual_type,
                      ((X.AtomType) actual_type).to_string() ?? "unknown",
                      (long) resolved_type,
                      extra_type == null ? "unresolved" : ((ExtraAtomType) extra_type).to_string());
         */
    }

    ~XWindowPropertyReader() {
        if (data != null) {
            X.free(data);
            data = null;
        }
    }

    public bool is_valid() {
        return actual_format != 0;
    }

    public ulong get_n_items() {
        return n_items;
    }

    public int get_actual_format() {
        return actual_format;
    }

    public ulong get_actual_type() {
        return actual_type;
    }

    public ulong get_resolved_type() {
        return resolved_type;
    }

    public string get_name() {
        return display.get_atom_name(atom);
    }

    public bool get_bool(out bool @value) {
        if (n_items > 0) {
            int tmp_val = resolve_numeric_atom(data, 0);
            @value = tmp_val != 0;
            return true;
        }

        @value = false;
        return false;
    }

    public bool get_int(out int @value) {
        if (n_items > 0) {
            @value = resolve_numeric_atom(data, 0);
            return true;
        }

        @value = 0;
        return false;
    }

    public int[] get_int_array() {
        int[] resolved_values = new int[n_items];
        for (ulong i = 0; i < n_items; ++i) {
            resolved_values[i] = resolve_numeric_atom(data, i);
        }
        return resolved_values;
    }

    public X.Point? get_point() {
        var values = get_int_array();
        if (values.length != 2) {
            return null;
        }

        return { (short) values[0], (short) values[1] };
    }

    public X.Rectangle? get_rect() {
        var values = get_int_array();
        if (values.length != 4) {
            return null;
        }

        return { (short) values[0], (short) values[1], (short) values[2], (short) values[3] };
    }

    public X.Rectangle[] get_rect_array() {
        var values = get_int_array();
        if (values.length % 4 != 0) {
            return {};
        }

        var rects = new X.Rectangle[values.length / 4];
        for (var i = 0; i < rects.length; ++i) {
            var j = i * 4;
            rects[i] = {
                (short) values[j],
                (short) values[j + 1],
                (short) values[j + 2],
                (short) values[j + 3]
            };
        }

        return rects;
    }

    public FrameExtents ? get_extents() {
        var values = get_int_array();
        if (values.length != 4) {
            return null;
        }

        return { (int) values[0], (int) values[1], (int) values[2], (int) values[3] };
    }

    public string get_string() {
        var strings = get_string_array();
        return strings.length > 0 ? strings[0] : null;
    }

    public string[] get_string_array() {
        string[] values = new string[0];
        if (n_items < 1) {
            return values;
        }

        unowned char* p = data;

        int j = 0;
        for (int i = 0; i < n_items; ) {
            var format = string_formatting_map.lookup((uint) resolved_type);

            switch (resolved_type) {
            case ExtraAtomType.UTF8_STRING :
            case XA_STRING :
                values.resize(j + 1);
                char* char_ptr = p + i;
                unowned string converted_str = (string) char_ptr;
                values[j++] = converted_str;
                i += converted_str.length + 1;
                break;

            case X.XA_ATOM :
                var v = resolve_numeric_atom(p, i);
                string name = display.get_atom_name(v) ?? "<unknown>";
                values.resize(j + 1);
                values[j++] = name;
                ++i;
                break;

            case XA_INTEGER :
            case X.XA_CARDINAL :
            case X.XA_WINDOW :
            case X.XA_WM_HINTS :
            case X.XA_WM_SIZE_HINTS :
            case X.XA_PIXMAP:
                var v = resolve_numeric_atom(p, i);
                values.resize(j + 1);
                values[j++] = v.to_string(format ?? "%ld");
                ++i;
                break;

            default:
                stderr.printf("Failed to parse type [%s]: %u(%u) len=%lu\n",
                              get_name(),
                              (uint) actual_type, (uint) resolved_type, n_items);
                return values;
            }
        }

        return values;
    }

    /**
     * Casts and returns the value of an atom to int.
     *
     * Every value associated with an atom is in fact a value-pair where the actual value is
     * followed by a null value.
     *
     * This function extracts the value associated with the atom, observing its size.  It also
     * positions the pointer on the next value, skipping over the null that always accompanies each
     * value.
     *
     * @param value a pointer to a value-pair containing the numeric value to extract.
     * @param index index in the value array
     * @return the extracted numeric value, or -1 if the actual format is not supported.
     */
    private int resolve_numeric_atom(void* value, ulong index = 0) {
        assert(index < n_items);

        switch (actual_format) {
        case 32:
            unowned int32* p = value;
            int32 v = *(p + (index << 1));
            return v;

        case 16:
            unowned int16* p = value;
            int16 v = *(p + (index << 1));
            return v;

        case 8:
            unowned int8* p = value;
            int8 v = *(p + (index << 1));
            return v;

        default:
            return -1;
        }
    }
}