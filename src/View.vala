using Gtk;

public class View : Gtk.ScrolledWindow {
    protected Gtk.Box container;

    public View () {
        // FIXME: make this quantity dependant on font size
        container = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        add (container);
        reset ();

        // FIXME: make this quantity dependant on font size
        margin = 10;
        propagate_natural_height = true;
    }

    protected void reset () {
        container.foreach (widget => {
            container.remove (widget);
        });

        container.valign = Gtk.Align.START;
    }

    protected void render_empty (string empty_message) {
        container.add (new EmptyViewWidget (empty_message));
        container.valign = Gtk.Align.CENTER;
    }

    protected void add_row (string label, Gtk.Widget field) {
        assert (field != null);

        var frame = new Gtk.Frame (label);
        frame.add (field);

        var row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        row.pack_start (frame);

        container.add (row);
    }

    protected Gtk.Widget create_field (string[] values) {
        if (values.length < 2) {
            return create_text_view (values[0]);
        }

        return create_list_box (values);
    }

    protected Gtk.Widget create_list_box (string[] values) {
        var listbox = new Gtk.ListBox ();
        foreach (var v in values) {
            var label = new Gtk.Label (v);
            label.halign = Gtk.Align.START;
            label.hexpand = true;

            var row = new Gtk.ListBoxRow ();
            row.add (label);
            listbox.add (row);
        }
        return listbox;
    }

    protected Gtk.Widget create_text_view (string? text) {
        var buffer = new Gtk.TextBuffer (null);
        buffer.set_text (text ?? "");

        var text_view = new Gtk.TextView ();
        text_view.buffer = buffer;
        text_view.cursor_visible = false;
        text_view.editable = false;
        text_view.margin = 5;

        return text_view;
    }

    protected void add_vertical_spacer () {
        assert (container != null);
        var spacer = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        spacer.vexpand = true;
        container.add (spacer);
    }
}