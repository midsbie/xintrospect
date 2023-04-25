using GLib;
using Gtk;
using X;

public class WindowParentsTreeView : WindowTreeView {
    X.Window? xid_at_cursor = null;
    EnumeratedXWindow[] enumerated_windows = {};

    public WindowParentsTreeView (X.Display display) {
        base (display);

        update_model ();
        ApplicationEventBus.get_instance ().active_window_changed.connect (on_active_window_changed);
        cursor_changed.connect (on_cursor_changed);

        if (xid_at_cursor != null) {
            GLib.Timeout.add (100, () => {
                ApplicationEventBus.get_instance ().active_window_changed.emit (xid_at_cursor);
                return false;
            });
        }
    }

    public void update_model (X.Window? new_xid_at_cursor = null) {
        if (new_xid_at_cursor == null) {
            xid_at_cursor = X.get_active_window (display) ?? display.default_root_window ();
            // ApplicationEventBus.get_instance ().active_window_changed.emit (new_active_xid);
            stdout.printf ("Active window set to 0x%lx\n", xid_at_cursor);
        } else {
            xid_at_cursor = new_xid_at_cursor;
        }

        stdout.printf ("Active window set to 0x%lx\n", xid_at_cursor);

        new XWindowEnumerator (display).get_parents (xid_at_cursor, out enumerated_windows);

        model = store = new Gtk.TreeStore (2, typeof (string), typeof (string));
        foreach (var w in enumerated_windows) {
            Gtk.TreeIter iter;
            string formatted_xid = "0x%lx".printf (w.window);

            store.append (out iter, null);
            store.set_value (iter, 0, formatted_xid);
            store.set_value (iter, 1, w.name == null ||
                             w.name.length == 0 ? "-" : w.name);

            if (w.window == xid_at_cursor) {
                var path = store.get_path (iter);
                set_cursor (path, null, false);
            }
        }

        expand_all ();
        show_all ();
    }

    private bool should_update_model (X.Window new_active_xid) {
        foreach (var w in enumerated_windows) {
            if (w.window == new_active_xid) {
                return false;
            }
        }

        return true;
    }

    private void on_active_window_changed (X.Window new_active_xid) {
        if (should_update_model (new_active_xid)) {
            update_model (new_active_xid);
        }
    }

    private void on_cursor_changed () {
        var path = get_active_row ();
        if (path == null) {
            return;
        }

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