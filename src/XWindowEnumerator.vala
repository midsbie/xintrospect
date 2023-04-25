public struct EnumeratedXWindowHierarchy {
    X.Window window;
    string name;
    EnumeratedXWindowHierarchy[] children;
}

public struct EnumeratedXWindow {
    X.Window window;
    string name;
}

public class XWindowEnumerator {
    unowned X.Display display;
    ExtraAtomTypes extra_types;

    public XWindowEnumerator(X.Display display) {
        this.display = display;
        extra_types = new ExtraAtomTypes(display);
    }

    public EnumeratedXWindowHierarchy get_hierarchy(X.Window? from_window = null) {
        EnumeratedXWindowHierarchy enumerated_window;
        bool is_root = from_window == null;

        enumerate_children(from_window ?? display.default_root_window(), out enumerated_window);
        if (is_root) {
            enumerated_window.name = "Root";
        }
        return enumerated_window;
    }

    public void get_parents(X.Window window,
                            out EnumeratedXWindow[] enumerated_windows) {
        X.Window root;
        X.Window parent;
        X.Window[] children;
        enumerated_windows = new EnumeratedXWindow[0];

        stdout.printf("Enumerating parent windows for 0x%lx\n", window);

        while (true) {
            display.query_tree(window, out root, out parent, out children);

            EnumeratedXWindow enumerated_window = { window, get_window_name(window) ?? "-" };
            enumerated_windows.resize(enumerated_windows.length + 1);
            enumerated_windows[enumerated_windows.length - 1] = enumerated_window;

            stdout.printf("Adding window to parents list: 0x%lx %s | parent=0x%lx\n",
                          window, enumerated_window.name, parent);
            if (parent == 0 || window == parent) {
                enumerated_windows[enumerated_windows.length - 1].name = "Root";
                break;
            }

            window = parent;
        }

        // Reverse array in place
        var j = enumerated_windows.length;
        var l = j >> 1;
        for (var i = 0; i < l; ++i ) {
            var t = enumerated_windows[i];
            enumerated_windows[i] = enumerated_windows[--j];
            enumerated_windows[j] = t;
        }
    }

    public X.Window? find_client_window(EnumeratedXWindowHierarchy * enumerated_windows) {
        assert(enumerated_windows != null);

        var reader = XWindowPropertyReader
             .for_atom_name(display, enumerated_windows->window, "WM_STATE");
        if (reader != null && reader.get_n_items() > 0) {
            return enumerated_windows->window;
        }

        foreach (var child in enumerated_windows->children) {
            var xid = find_client_window(&child);
            if (xid != null) {
                return xid;
            }
        }

        return null;
    }

    public string ? get_window_name(X.Window window) {
        var reader = XWindowPropertyReader.for_atom_name(display, window, "NET_WM_NAME", extra_types)
            ?? XWindowPropertyReader.for_atom_name(display, window, "_NET_WM_NAME", extra_types);
        if (reader == null) {
// stdout.printf("Window 0x%lx: NET_WM_NAME or _NET_WM_NAME properties not found\n",
// (ulong) window);
            return null;
        }

        return reader.get_string();
    }

    private void enumerate_children(X.Window window,
                                    out EnumeratedXWindowHierarchy enumerated_window) {
        X.Window root;
        X.Window parent;
        X.Window[] children;

        display.query_tree(window, out root, out parent, out children);
        enumerated_window = {};
        enumerated_window.window = window;
        enumerated_window.name = get_window_name(window);
        enumerated_window.children = new EnumeratedXWindowHierarchy[children.length];

        uint i = 0;
        foreach (var child in children) {
            EnumeratedXWindowHierarchy enumerated_child;
            enumerate_children(child, out enumerated_child);
            enumerated_window.children[i++] = enumerated_child;
        }
    }
}