using Gtk;

public class EmptyViewWidget : Gtk.Box {
    public EmptyViewWidget (string empty_text) {
        orientation = Gtk.Orientation.VERTICAL;
        // FIXME: make this quantity dependant on font size
        spacing = 10;

        Gtk.Image img = new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.BUTTON);
        pack_start (img, true, true, 0);

        var label = new Gtk.Label (empty_text);
        label.set_line_wrap (true);
        label.set_justify (Gtk.Justification.CENTER);
        // label.modify_font (Pango.FontDescription.from_string ("Arial 14"));
        pack_start (label, true, true, 0);
    }
}