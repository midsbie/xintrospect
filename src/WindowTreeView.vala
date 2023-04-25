using GLib;
using Gtk;
using X;

public class WindowTreeView : Gtk.TreeView {
    protected unowned X.Display display;
    protected Gtk.TreeStore store;

    public WindowTreeView (X.Display display) {
        this.display = display;
        vexpand = true;

        var col = new Gtk.TreeViewColumn ();
        col.title = "XID";
        var text_cell = new Gtk.CellRendererText ();
        col.pack_start (text_cell, true);
        col.add_attribute (text_cell, "text", 0);
        append_column (col);

        col = new Gtk.TreeViewColumn ();
        col.title = "Name";
        text_cell = new Gtk.CellRendererText ();
        col.pack_start (text_cell, true);
        col.add_attribute (text_cell, "text", 1);
        append_column (col);
    }

    public Gtk.TreePath? get_active_row () {
        Gtk.TreePath? iter;
        Gtk.TreeViewColumn? col;
        get_cursor (out iter, out col);
        return iter;
    }
}