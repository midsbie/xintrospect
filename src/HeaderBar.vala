using GLib;
using Gtk;

public class HeaderBar : Gtk.HeaderBar {
    public const string ACTION_GRAB_WINDOW = "grab_window";

    public HeaderBar(X.Display display) {
        set_title(PROGRAM_NAME);

        var toolbar = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        Gtk.Button button;

        create_button("window-new", out button);
        button.action_name = "app." + ACTION_GRAB_WINDOW;
        toolbar.add(button);

        create_button("view-list-symbolic", out button);
        button.clicked.connect(() => {
            var dialog = new WindowSelectorDialog(display);
            dialog.run();
            dialog.destroy();
        });
        toolbar.add(button);

        pack_start(toolbar);
        pack_end(new ApplicationMenu());
    }

    void create_button(string icon_name, out Gtk.Button button) {
        button = new Gtk.Button();
        button.add(new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.BUTTON));
    }
}