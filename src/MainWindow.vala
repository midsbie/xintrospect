using Gtk;

public class MainWindow : Gtk.ApplicationWindow {
    public MainWindow (X.Display display) {
        var header = new HeaderBar (display);
        header.show_close_button = true;
        set_titlebar (header);

        var pane = new MainPaneView (display);
        add (pane);
        default_width = 1024;
        default_height = 800;
    }
}