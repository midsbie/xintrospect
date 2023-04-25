using X;

public class XWindowPropertyEnumerator {
    unowned X.Display display;
    X.Window window;
    ExtraAtomTypes? extra_types;
    GLib.HashTable<string, X.Atom?> properties = new GLib.HashTable<
        string, X.Atom?> (str_hash, str_equal);

    public XWindowPropertyEnumerator (X.Display display,
        X.Window window,
        ref ExtraAtomTypes? extra_types) {
        this.display = display;
        this.window = window;
        this.extra_types = extra_types;

        var props = display.list_properties (window);

        foreach (var property in props) {
            string name = display.get_atom_name (property);
            properties[name] = property;
        }
    }

    public bool is_empty () {
        return properties.length < 1;
    }

    public void @foreach (GLib.HFunc<string, X.Atom?> @callback) {
        properties.for_each (@callback);
    }

    public void foreach_sorted (GLib.HFunc<string, X.Atom?> @callback) {
        var sorted_keys = properties.get_keys ();
        sorted_keys.sort (GLib.strcmp);

        unowned var iter = sorted_keys;
        while (iter != null) {
            var key = iter.data;
            var prop = properties.lookup (key);
            @callback (key, prop);
            iter = iter.next;
        }
    }

    public bool has (string name) {
        return properties.lookup (name) != null;
    }

    public XWindowPropertyReader ? get_reader (string name) {
        var atom = properties.get (name);
        if (atom == null) {
            return null;
        }

        return new XWindowPropertyReader (display, window, atom, extra_types);
    }
}