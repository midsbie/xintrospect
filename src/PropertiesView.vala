using Gtk;
using X;

public class PropertiesView : View {
    unowned X.Display display;
    ExtraAtomTypes extra_types;

    public PropertiesView (X.Display display) {
        this.display = display;
        extra_types = new ExtraAtomTypes (display);
        ApplicationEventBus.get_instance ().active_window_changed.connect (on_update);
    }

    private void render_properties (XWindowPropertyEnumerator properties) {
        properties.foreach_sorted ((name, atom) => {
            var reader = properties.get_reader (name);
            if (reader == null) {
                stderr.printf ("Failed to obtain reader for property: %s\n", name);
                return;
            }

            Gtk.Widget? field = XWindowPropertyWidgetFactory.render (name, reader);
            if (field == null) {
                var @value = XWindowPropertyStringRenderer.render (name, reader);
                field = create_field (@value);
            }

            add_row (name, field);
        });

        add_vertical_spacer ();
    }

    private void on_update (X.Window window) {
        var properties = new XWindowPropertyEnumerator (display, window, ref extra_types);
        reset ();

        if (properties.is_empty ()) {
            render_empty ("No properties available");
        } else {
            render_properties (properties);
        }

        show_all ();
    }
}