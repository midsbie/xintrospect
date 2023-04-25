using X;
using Gtk;

public class MainPaneView : Gtk.Paned {
    public MainPaneView(X.Display display) {
        set_orientation(Gtk.Orientation.HORIZONTAL);

        var sub_pane = new Gtk.Paned(Gtk.Orientation.VERTICAL);
        sub_pane.position = 100;
        sub_pane.pack1(wrap_scrolled_window(new WindowParentsTreeView(display)), false, true);
        sub_pane.pack2(wrap_scrolled_window(new AttributesView(display)), false, false);
        pack1(sub_pane, false, false);

        var properties_view = new PropertiesView(display);
        pack2(properties_view, false, false);
    }

    private Gtk.Widget wrap_scrolled_window(Gtk.Widget widget) {
        var scrolled_window = new Gtk.ScrolledWindow(null, null);
        scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scrolled_window.add(widget);
        return scrolled_window;
    }
}