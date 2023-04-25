using X;
using Gtk;

public class ApplicationGui : Gtk.Application {
    X.Display display;
    MainWindow window;

    private const GLib.ActionEntry[] action_entries = {
        { HeaderBar.ACTION_GRAB_WINDOW, on_grab_window },
        { ApplicationMenu.ACTION_ABOUT, on_show_about },
    };

    public ApplicationGui () {
        // Calling XInitThreads in an attempt to resolve the following runtime error:
        //
        // [xcb] Unknown request in queue while dequeuing
        // [xcb] Most likely this is a multi-threaded client and XInitThreads has not been called
        // [xcb] Aborting, sorry about that.
        X.init_threads ();
    }

    protected override void activate () {
        display = new X.Display ();
        window = new MainWindow (display);
        add_window (window);
        window.show_all ();

        add_action_entries (action_entries, this);
    }

    private void on_grab_window () {
        stdout.printf ("Grabbing window...\n");
        var selector = new LiveWindowSelector (display);
        var window = selector.capture ();
        stdout.printf ("Window grab ended: 0x%lx\n", window == null ? -1 : window);
        if (window != null) {
            ApplicationEventBus.get_instance ().active_window_changed.emit (window);
        }
    }

    private void on_show_about () {
        var about_dialog = new ApplicationAboutDialog ();
        about_dialog.run ();
        about_dialog.destroy ();
    }
}