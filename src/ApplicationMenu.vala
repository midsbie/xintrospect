using Gtk;

public class ApplicationMenu : Gtk.MenuButton {
    public const string ACTION_ABOUT = "about";

    public ApplicationMenu () {
        var menu = new GLib.Menu ();

        var about_item = new GLib.MenuItem ("About", "app." + ACTION_ABOUT);
        menu.append_item (about_item);

        Gtk.Image img = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
        add (img);
        set_menu_model (menu);
    }
}