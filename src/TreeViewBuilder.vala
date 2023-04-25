using Gtk;

public class TreeViewBuilder {
    Gtk.TreeView view;
    Gtk.TreeStore store;

    public TreeViewBuilder(string[] col_names) {
        view = new Gtk.TreeView();

        var types = new GLib.Type[col_names.length];
        for (var i = 0; i < col_names.length; i++) {
            types[i] = GLib.Type.STRING;
        }
        store = new Gtk.TreeStore.newv(types);
        view.model = store;

        for (var i = 0; i < col_names.length; ++i) {
            var col = new Gtk.TreeViewColumn();
            col.title = col_names[i];

            var text_cell = new Gtk.CellRendererText();
            col.pack_start(text_cell, true);
            col.add_attribute(text_cell, "text", i);
            view.append_column(col);
        }
    }

    public Gtk.TreeView get() {
        return view;
    }

    public void add(string[] values) {
        Gtk.TreeIter iter;
        store.append(out iter, null);

        for (var i = 0; i < values.length; ++i) {
            store.set_value(iter, i, values[i]);
        }
    }
}