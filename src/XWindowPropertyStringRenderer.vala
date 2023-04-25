using X;

public class XWindowPropertyStringRenderer {
    public static string[] render(string atom_name, XWindowPropertyReader reader) {
        assert(reader != null);

        switch (atom_name) {
        case "XFree86_has_VT":
        case "XKLAVIER_ALLOW_SECONDARY":
            return format_bool(reader);

        case "_NET_ACTIVE_WINDOW":
            return format_xid(reader);

        case "_NET_DESKTOP_VIEWPORT":
            return format_point(reader);

        case "_NET_DESKTOP_GEOMETRY":
            return format_size(reader);

        case "_NET_DESKTOP_LAYOUT":
            return format_desktop_layout(reader);

        case "_NET_FRAME_EXTENTS":
            return format_extents(reader);

        case "_NET_WORKAREA":
            return format_rect_array(reader);

        case "_NET_WM_OPAQUE_REGION":
            return format_rect(reader);

        case "_MOTIF_WM_HINTS":
            return format_hex_list(reader);

        default:
            return reader.get_string_array();
        }
    }

    public static string[] format_desktop_layout(XWindowPropertyReader reader) {
        var values = reader.get_int_array();
        if (values.length != 4) {
            return reader.get_string_array();
        }

        var desktop_layout = new Xcb.DesktopLayout(new Xcb.DesktopLayout.Orientation(values[0]),
                                                   values[1], values[2],
                                                   new Xcb.DesktopLayout.StartingCorner(values[3]));
        return {
                   "Orientation=%s (%d)".printf(desktop_layout.orientation.to_string(),
                                                desktop_layout.orientation.get()),
                   values[1].to_string("Columns=%d"),
                   values[2].to_string("Rows=%d"),
                   "Starting corner=%s (%d)".printf(desktop_layout.starting_corner.to_string(),
                                                    desktop_layout.starting_corner.get())
        };
    }

    public static string[] format_bool(XWindowPropertyReader reader) {
        bool v;
        if (!reader.get_bool(out v)) {
            return {};
        }
        return { v ? "True" : "False" };
    }

    public static string[] format_xid(XWindowPropertyReader reader) {
        var xids = reader.get_int_array();

        // Skip null elements
        var length = xids.length;
        while (xids[length - 1] == 0) {
            --length;
        }

        var r = new string[length];
        for (var i = 0; i < length; ++i) {
            r[i] = xids[i].to_string("0x%lx");
        }
        return r;
    }

    public static string[] format_hex_list(XWindowPropertyReader reader) {
        var values = reader.get_int_array();

        var r = new string[values.length];
        for (var i = 0; i < values.length; ++i) {
            r[i] = values[i].to_string("0x%lx");
        }

        return { string.joinv(", ", r) };
    }

    public static string[] format_point(XWindowPropertyReader reader) {
        var point = reader.get_point();
        if (point == null) {
            return {};
        }

        return {
                   "(x=%d, y=%d)".
                    printf(point.x, point.y)
        };
    }

    public static string[] format_size(XWindowPropertyReader reader) {
        var point = reader.get_point();
        if (point == null) {
            return {};
        }

        return {
                   "(width=%d, height=%d)".
                    printf(point.x, point.y)
        };
    }

    public static string[] format_rect(XWindowPropertyReader reader) {
        var rect = reader.get_rect();
        if (rect == null) {
            return {};
        }

        return { rect_to_string(rect) };
    }

    public static string[] format_rect_array(XWindowPropertyReader reader) {
        var rect = reader.get_rect_array();
        var formatted_rects = new string[rect.length];
        for (var i = 0; i < rect.length; ++i) {
            formatted_rects[i] = rect_to_string(rect[i]);
        }
        return formatted_rects;
    }

    public static string[] format_extents(XWindowPropertyReader reader) {
        var extents = reader.get_extents();
        if (extents == null) {
            return {};
        }

        return {
                   "(left=%d, top=%d) (right=%d, bottom=%d)".
                    printf(extents.left,
                           extents.top,
                           extents.right,
                           extents.bottom)
        };
    }

    public static string rect_to_string(X.Rectangle rect) {
        return "(x=%d, y=%d) (width=%d, height=%d)".
                printf(rect.x,
                       rect.y,
                       rect.width,
                       rect.height);
    }
}