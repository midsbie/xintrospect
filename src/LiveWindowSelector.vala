using X;

public class LiveWindowSelector : Object {
    private unowned X.Display display;

    public LiveWindowSelector (X.Display display) {
        this.display = display;
    }

    public X.Window? capture () {
        int status;
        Cursor cursor;
        X.Event @event;
        X.Window target_win = X.None;
        X.Window root = display.default_root_window ();
        int buttons = 0;

        X.WindowAttributes attrs;
        display.get_window_attributes (root, out attrs);
        long previous_event_mask = attrs.your_event_mask;

        cursor = X.create_font_cursor (display, X.Cursors.CROSSHAIR);

        status = display.grab_pointer (root, false,
                                       X.EventMask.ButtonPressMask | X.EventMask.ButtonReleaseMask,
                                       X.GrabMode.Sync,
                                       X.GrabMode.Async, root,
                                       (int) cursor, (int) X.CURRENT_TIME);
        if (status != X.Success) {
            stderr.printf ("Can't grab the mouse.\n");
            return null;
        }

        display.flush ();

        while ((target_win == X.None) || (buttons != 0)) {
            display.allow_events (X.AllowEventsMode.SyncPointer, (int) X.CURRENT_TIME);
            display.flush ();

            display.window_event (root,
                                  X.EventMask.ButtonPressMask | X.EventMask.ButtonReleaseMask,
                                  out @event);
            switch (@event.type) {
            case X.EventType.ButtonPress :
                if (target_win == X.None) {
                    target_win = event.xbutton.subwindow; /* window selected */
                    if (target_win == X.None)target_win = root;
                }
                buttons++;
                break;
            case X.EventType.ButtonRelease:
                if (buttons > 0) {
                    --buttons;
                }
                break;
            }
        }

        cursor = X.create_font_cursor (display, X.Cursors.ARROW);
        display.ungrab_pointer ((int) X.CURRENT_TIME);
        display.select_input (root, previous_event_mask);
        display.flush ();

        if (target_win == root) {
            return target_win;
        }

        var window_enumerator = new XWindowEnumerator (display);
        var enumerated_windows = window_enumerator.get_hierarchy (target_win);
        return window_enumerator.find_client_window (&enumerated_windows);
    }
}