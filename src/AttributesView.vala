using Gtk;
using X;

public class AttributesView : View {
    unowned X.Display display;

    public AttributesView (X.Display display) {
        this.display = display;
        ApplicationEventBus.get_instance ().active_window_changed.connect (on_update);
    }

    private void add_attribute_row (string name, string[] values) {
        add_row (name, create_field (values));
    }

    private void on_update (X.Window window) {
        stdout.printf ("Rendering attributes: 0x%lx\n", window);
        reset ();

        X.WindowAttributes attrs;
        display.get_window_attributes (window, out attrs);

        var widget = WidgetFactory.render_point ({ attrs.x, attrs.y });
        add_row ("Position", widget);

        widget = WidgetFactory.render_size ({ attrs.width, attrs.height });
        add_row ("Size", widget);

        var builder = new TreeViewBuilder ({ "Field", "Value" });
        builder.add ({ "Border width", attrs.border_width.to_string ("%d") });
        builder.add ({ "Depth", attrs.depth.to_string ("%d") });
        builder.add ({ "Class", X.StringMapping.WindowClassType.to_string (attrs.class) });
        builder.add ({ "Bit gravity", X.StringMapping.GravityType.to_string (attrs.bit_gravity) });
        builder.add ({ "Window gravity", X.StringMapping.GravityType.to_string (attrs.win_gravity) });
        builder.add ({ "Backing store", X.StringMapping.BackingStoreType.to_string (attrs.backing_store) });
        builder.add ({ "Backing planes", attrs.backing_planes.to_string ("0x%lx") });
        builder.add ({ "Backing pixel", attrs.backing_pixel.to_string ("%lx") });
        builder.add ({ "Save under", attrs.save_under.to_string () });
        builder.add ({ "Map installed", attrs.map_installed.to_string () });
        builder.add ({ "Map state", X.StringMapping.MapStateType.to_string (attrs.map_state) });
        builder.add ({ "Override direct", attrs.override_redirect.to_string () });
        add_row ("Miscellaneous", builder.get ());

        // add_attribute_row (FieldId.VISUAL, "Visual");
        // add_attribute_row (FieldId.COLORMAP, "Colormap");

        add_attribute_row ("Events mask", X.StringMapping.EventMask.to_string_array (attrs.all_event_masks));
        add_attribute_row ("Do not propagate", X.StringMapping.EventMask.to_string_array (attrs.do_not_propagate_mask));

        add_vertical_spacer ();
        show_all ();
    }
}