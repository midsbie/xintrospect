using X;

public class ApplicationEventBus {
    private static ApplicationEventBus? instance;

    public signal void active_window_changed (X.Window xid);

    private ApplicationEventBus () {}

    public static ApplicationEventBus get_instance () {
        if (instance == null) {
            instance = new ApplicationEventBus ();
        }
        return instance;
    }
}