using Gtk;

public class XWindowPropertyWidgetFactory {
    public static Gtk.Widget? render(string atom_name, XWindowPropertyReader reader) {
        switch (reader.get_resolved_type()) {
        case X.XA_WM_HINTS :
            return render_wm_hints(reader);

        case X.XA_WM_SIZE_HINTS:
            return render_wm_size_hints(reader);

        case ExtraAtomType.WM_STATE:
            return render_wm_state(reader);

        default:
            break;
        }

        switch (atom_name) {
        case "_NET_DESKTOP_LAYOUT":
            return render_desktop_layout(reader);

        case "_NET_DESKTOP_GEOMETRY":
            return render_size(reader);

        case "_NET_DESKTOP_VIEWPORT":
            return render_point(reader);

        case "_GTK_FRAME_EXTENTS":
        case "_NET_FRAME_EXTENTS":
            return render_frame_extents(reader);

        case "_NET_WM_ICON":
            return render_icon(reader);

        case "_NET_WM_ICON_GEOMETRY":
        case "_NET_WM_OPAQUE_REGION":
            return render_rect_array(reader);

        case "_NET_WORKAREA":
            return render_rect_array(reader);

        default:
            return null;
        }
    }

    public static Gtk.TreeView? render_desktop_layout(XWindowPropertyReader reader) {
        var data = reader.get_int_array();
        if (data.length != 4) {
            stderr.printf("Invalid _NET_DESKTOP_LAYOUT data length: actual %d != expected 4\n",
                          data.length);
            return null;
        }

        var desktop_layout = new Xcb.DesktopLayout(new Xcb.DesktopLayout.Orientation(data[0]),
                                                   data[1], data[2],
                                                   new Xcb.DesktopLayout.StartingCorner(data[3]));
        return WidgetFactory.render_desktop_layout(desktop_layout);
    }

    public static Gtk.TreeView? render_wm_hints(XWindowPropertyReader reader) {
        var data = reader.get_int_array();
        if (data.length != 9) {
            stderr.printf("Invalid WM_SIZE data length: actual %d != expected 9\n", data.length);
            return null;
        }

        X.WmHints wm_hints = { data[1] != 0, data[2], data[3], data[4], data[5], data[6],
                               data[7], data[8] };
        return WidgetFactory.render_wm_hints(wm_hints);
    }

    public static Gtk.TreeView? render_wm_size_hints(XWindowPropertyReader reader) {
        var data = reader.get_int_array();
        if (data.length != 18) {
            stderr.printf("Invalid WM_HINTS data length: actual %d != expected 18\n", data.length);
            return null;
        }

        X.WmSizeHints wm_size = { { data[1], data[2] },
                                  { data[3], data[4] },
                                  { data[5], data[6] },
                                  { data[7], data[8] },
                                  { data[9], data[10] },
                                  { data[11], data[12] },
                                  { data[13], data[14] },
                                  { data[15], data[16] },
                                  data[17] };
        return WidgetFactory.render_wm_size_hints(wm_size);
    }

    public static Gtk.TreeView? render_wm_state(XWindowPropertyReader reader) {
        var data = reader.get_int_array();
        if (data.length != 2) {
            stderr.printf("Invalid WM_STATE data length: actual %d != expected 4\n", data.length);
            return null;
        }

        X.WmState state = { data[0], data[1] };
        return WidgetFactory.render_wm_state(state);
    }

    public static Gtk.TreeView? render_frame_extents(XWindowPropertyReader reader) {
        var extents = reader.get_extents();
        if (extents == null) {
            stderr.printf("Unable to extract frame extents from property data\n");
            return null;
        }
        return WidgetFactory.render_frame_extents(extents);
    }

    public static Gtk.Widget? render_icon(XWindowPropertyReader reader) {
        var data = reader.get_int_array();
        return WidgetFactory.render_icon(data);
    }

    public static Gtk.TreeView? render_point(XWindowPropertyReader reader) {
        var point = reader.get_point();
        if (point == null) {
            stderr.printf("Unable to extract point from property data\n");
            return null;
        }

        return WidgetFactory.render_point(point);
    }

    public static Gtk.TreeView? render_rect(XWindowPropertyReader reader) {
        var rect = reader.get_rect();
        if (rect == null) {
            stderr.printf("Unable to extract rect from property data\n");
            return null;
        }

        return WidgetFactory.render_rect(rect);
    }

    public static Gtk.TreeView? render_rect_array(XWindowPropertyReader reader) {
        var rects = reader.get_rect_array();
        if (rects.length < 1) {
            stderr.printf("Unable to extract rect array from property data\n");
            return null;
        }

        return WidgetFactory.render_rect_array(rects);
    }

    public static Gtk.TreeView? render_size(XWindowPropertyReader reader) {
        var point = reader.get_point();
        if (point == null) {
            stderr.printf("Unable to extract size from property data\n");
            return null;
        }

        return WidgetFactory.render_size(point);
    }
}