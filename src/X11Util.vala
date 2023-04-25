namespace X {
    public static X.Window ? get_active_window (X.Display display) {
        X.Atom atom = display.intern_atom ("_NET_ACTIVE_WINDOW", false);
        var reader = new XWindowPropertyReader (display, display.default_root_window (), atom);
        int active_xid;
        if (reader.get_int (out active_xid)) {
            return ((X.Window) active_xid);
        }

        return null;
    }
}