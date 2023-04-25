using GLib;
using Gtk;

public class WindowSelectorDialog : Gtk.Dialog {
    WindowHierarchyTreeView tree_view;

    public WindowSelectorDialog (X.Display display) {
        tree_view = new WindowHierarchyTreeView (display);

        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (tree_view);
        get_content_area ().add (scrolled_window);

        set_size_request (400, 500);
        show_all ();

        ApplicationEventBus.get_instance ().active_window_changed.connect (destroy);
    }
}