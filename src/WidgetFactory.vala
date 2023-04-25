using Gtk;

public class WidgetFactory {
    public static Gtk.TreeView? render_desktop_layout(Xcb.DesktopLayout desktop_layout) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "Orientation",
                      "%s (%d)".printf(desktop_layout.orientation.to_string(),
                                       desktop_layout.orientation.get()) });
        builder.add({ "Columns", desktop_layout.columns.to_string("%d") });
        builder.add({ "Rows", desktop_layout.rows.to_string("%d") });
        builder.add({ "Starting corner",
                      "%s (%d)".printf(desktop_layout.starting_corner.to_string(),
                                       desktop_layout.starting_corner.get()) });
        return builder.get();
    }

    public static Gtk.TreeView? render_wm_hints(X.WmHints wm_hints) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "Accepts input or input focus?", wm_hints.input ? "Yes" : "No" });
        builder.add({ "Initial state", X.StringMapping.StateType.to_string(wm_hints.initial_state) });
        builder.add({ "Icon pixmap", ((int) wm_hints.icon_pixmap).to_string("0x%lx") });
        builder.add({ "Icon window", ((int) wm_hints.icon_window).to_string("0x%lx") });
        builder.add({ "Icon X", wm_hints.icon_x.to_string("%d") });
        builder.add({ "Icon Y", wm_hints.icon_y.to_string("%d") });
        builder.add({ "Icon mask", ((int) wm_hints.icon_mask).to_string("0x%lx") });
        builder.add({ "Window group", ((int) wm_hints.window_group).to_string("0x%lx") });
        return builder.get();
    }

    public static Gtk.TreeView? render_wm_size_hints(X.WmSizeHints wm_size) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "Position", "x=%d y=%d".printf(wm_size.position.x, wm_size.position.y) });
        builder.add({ "Size", "width=%d height=%d".printf(wm_size.size.width, wm_size.size.height) });
        builder.add({ "Min size", "width=%d height=%d".printf(wm_size.min_size.width, wm_size.min_size.height) });
        builder.add({ "Max size", "width=%d height=%d".printf(wm_size.max_size.width, wm_size.max_size.height) });
        builder.add({ "Inc size", "width=%d height=%d".printf(wm_size.inc_size.width, wm_size.inc_size.height) });
        builder.add({ "Min aspect", "x=%d y=%d".printf(wm_size.min_aspect.x, wm_size.min_aspect.y) });
        builder.add({ "Max aspect", "x=%d y=%d".printf(wm_size.max_aspect.x, wm_size.max_aspect.y) });
        builder.add({ "Base size", "width=%d height=%d".printf(wm_size.max_aspect.x, wm_size.max_aspect.y) });
        builder.add({ "Gravity", X.StringMapping.GravityType.to_string(wm_size.window_gravity) });
        return builder.get();
    }

    public static Gtk.TreeView? render_wm_state(X.WmState state) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "State", X.StringMapping.StateType.to_string(state.state) });
        builder.add({ "Icon", "0x%lx".printf((int) state.icon) });
        return builder.get();
    }

    public static Gtk.TreeView? render_frame_extents(FrameExtents extents) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "Left", extents.left.to_string("%d") });
        builder.add({ "Top", extents.top.to_string("%d") });
        builder.add({ "Right", extents.right.to_string("%d") });
        builder.add({ "Bottom", extents.bottom.to_string("%d") });
        return builder.get();
    }

    public static Gtk.Image? render_icon(int[] data) {
        if (data.length < 3) {
            stderr.printf("Unable to extract icon dimensions from property data\n");
            return null;
        }

        int width = data[0];
        int height = data[1];
        int icon_size = width * height;
        if (data.length < icon_size + 2) {
            stderr.printf("Invalid icon data length: actual %d != expected %d\n",
                          data.length, icon_size + 2);
        }

        var pixbuf_data = new uint8[icon_size * sizeof (int)];
        int p = 0;
        for (int i = 0; i < icon_size; i++) {
            uint32 pixel = data[i + 2];
            pixbuf_data[p++] = (uint8) ((pixel >> 16) & 0xFF); // red
            pixbuf_data[p++] = (uint8) ((pixel >> 8) & 0xFF); // green
            pixbuf_data[p++] = (uint8) (pixel & 0xFF); // blue
            pixbuf_data[p++] = (uint8) ((pixel >> 24) & 0xFF); // alpha
        }

        var pixbuf = new Gdk.Pixbuf.from_data(pixbuf_data, Gdk.Colorspace.RGB, true, 8,
                                              width, height, width * 4);
        var image = new Gtk.Image();
        image.set_from_pixbuf(pixbuf);
        return image;
    }

    public static Gtk.TreeView? render_point(X.Point point) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "X", point.x.to_string("%d") });
        builder.add({ "Y", point.y.to_string("%d") });
        return builder.get();
    }

    public static Gtk.TreeView? render_rect(X.Rectangle rect) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "X", rect.x.to_string("%d") });
        builder.add({ "Y", rect.y.to_string("%d") });
        builder.add({ "Width", rect.width.to_string("%d") });
        builder.add({ "Height", rect.height.to_string("%d") });
        return builder.get();
    }

    public static Gtk.TreeView? render_rect_array(X.Rectangle[] rects) {
        var builder = new TreeViewBuilder({ "#", "X", "Y", "Width", "Height" });

        for (var i = 0; i < rects.length; ++i) {
            var rect = rects[i];
            builder.add({ i.to_string("%d"), rect.x.to_string("%d"), rect.y.to_string("%d"),
                          rect.width.to_string("%d"), rect.height.to_string("%d") });
        }

        return builder.get();
    }

    public static Gtk.TreeView? render_size(X.Point size) {
        var builder = new TreeViewBuilder({ "Field", "Value" });
        builder.add({ "Width", size.x.to_string("%d") });
        builder.add({ "Height", size.y.to_string("%d") });
        return builder.get();
    }
}