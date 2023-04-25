using Gtk;
using X;

using GLib;

public class WindowHierarchyTreeView : WindowTreeView {
    public WindowHierarchyTreeView (X.Display display) {
        base (display);
        update_model ();

        activate_on_single_click = true;
        row_activated.connect (on_row_activated);
    }

    public void update_model () {
        store = new Gtk.TreeStore (2, typeof (string), typeof (string));
        model = store;

        var enumerated_windows = new XWindowEnumerator (display).get_hierarchy ();
        update_children (enumerated_windows);

        expand_all ();
    }

    private void update_children (EnumeratedXWindowHierarchy enumerated_window,
                                  Gtk.TreeIter? parent_iter = null) {
        Gtk.TreeIter iter;
        string formatted_xid = "0x%lx".printf (enumerated_window.window);
        store.append (out iter, parent_iter);
        store.set_value (iter, 0, formatted_xid);
        store.set_value (iter, 1, enumerated_window.name == null ||
                         enumerated_window.name.length == 0 ? "-" : enumerated_window.name);

        foreach (var child in enumerated_window.children) {
            update_children (child, iter);
        }
    }

    private void on_row_activated (Gtk.TreePath path) {
        Gtk.TreeIter iter;
        if (!model.get_iter (out iter, path)) {
            stderr.printf ("Window hierarchy view: cannot find row for cursor\n");
            return;
        }

        GLib.Value xid_string;
        model.get_value (iter, 0, out xid_string);

        X.Window xid;
        xid_string.get_string ().scanf ("0x%lx", out xid);
        stdout.printf ("EVENT: window hierarchy view: cursor changed: %s\n",
                       xid_string.get_string ());

        ApplicationEventBus.get_instance ().active_window_changed.emit (xid);
    }
}