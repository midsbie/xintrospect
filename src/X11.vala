namespace X {
    enum Cursors {
        ARROW = 2,
        CROSSHAIR = 34,
    }

    public enum AtomType {
        PRIMARY = 1,
        SECONDARY,
        ARC,
        ATOM,
        BITMAP,
        CARDINAL,
        COLORMAP,
        CURSOR,
        CUT_BUFFER0,
        CUT_BUFFER1,
        CUT_BUFFER2,
        CUT_BUFFER3,
        CUT_BUFFER4,
        CUT_BUFFER5,
        CUT_BUFFER6,
        CUT_BUFFER7,
        DRAWABLE,
        FONT,
        INTEGER,
        PIXMAP,
        POINT,
        RECTANGLE,
        RESOURCE_MANAGER,
        RGB_COLOR_MAP,
        RGB_BEST_MAP,
        RGB_BLUE_MAP,
        RGB_DEFAULT_MAP,
        RGB_GRAY_MAP,
        RGB_GREEN_MAP,
        RGB_RED_MAP,
        STRING,
        VISUALID,
        WINDOW,
        WM_COMMAND,
        WM_HINTS,
        WM_CLIENT_MACHINE,
        WM_ICON_NAME,
        WM_ICON_SIZE,
        WM_NAME,
        WM_NORMAL_HINTS,
        WM_SIZE_HINTS,
        WM_ZOOM_HINTS,
        MIN_SPACE,
        NORM_SPACE,
        MAX_SPACE,
        END_SPACE,
        SUPERSCRIPT_X,
        SUPERSCRIPT_Y,
        SUBSCRIPT_X,
        SUBSCRIPT_Y,
        UNDERLINE_POSITION,
        UNDERLINE_THICKNESS,
        STRIKEOUT_ASCENT,
        STRIKEOUT_DESCENT,
        ITALIC_ANGLE,
        X_HEIGHT,
        QUAD_WIDTH,
        WEIGHT,
        POINT_SIZE,
        RESOLUTION,
        COPYRIGHT,
        NOTICE,
        FONT_NAME,
        FAMILY_NAME,
        FULL_NAME,
        CAP_HEIGHT,
        WM_CLASS,
        WM_TRANSIENT_FOR,
    }

    public enum Gravity {
        Forget,
        NorthWest,
        North,
        NorthEast,
        West,
        Center,
        East,
        SouthWest,
        South,
        SouthEast,
        Static
    }

    public enum BackingStore {
        NotUseful,
        WhenMapped,
        Always,
    }

    // Duplicate of X.MapState because it is unrecognized for whatever reason
    public enum MapStateAttr {
        IsUnmapped,
        IsUnviewable,
        IsViewable
    }

    public enum State {
        Withdrawn = 0,
        Normal = 1,
        Iconic = 3,
        Inactive = 4,
    }

    public struct Point {
        int x;
        int y;
    }

    public struct Size {
        int width;
        int height;
    }

    // Resolves linking error:
    //
    // FAILED: xdump
    // +  gcc  -o xdump xdump.p/meson-generated_src_main.c.o xdump.p/meson-generated_src_ApplicationCli.c.o xdump.p/meson-generated_src_ApplicationGui.c.o xdump.p/meson-generated_src_MainWindow.c.o xdump.p/meson-generated_src_HeaderBar.c.o xdump.p/meson-generated_src_ApplicationMenu.c.o xdump.p/meson-generated_src_ApplicationAboutDialog.c.o xdump.p/meson-generated_src_PaneView.c.o xdump.p/meson-generated_src_WindowHierarchyTreeView.c.o xdump.p/meson-generated_src_ContentView.c.o xdump.p/meson-generated_src_Page.c.o xdump.p/meson-generated_src_AttributesPage.c.o xdump.p/meson-generated_src_PropertiesPage.c.o xdump.p/meson-generated_src_x11.c.o xdump.p/meson-generated_src_ApplicationEventBus.c.o xdump.p/meson-generated_src_ExtraAtomTypes.c.o xdump.p/meson-generated_src_XWindowAttributes.c.o xdump.p/meson-generated_src_XWindowEnumerator.c.o xdump.p/meson-generated_src_XWindowPropertyEnumerator.c.o xdump.p/meson-generated_src_XWindowPropertyReader.c.o xdump.p/meson-generated_src_XWindowPropertyFormatter.c.o xdump.p/meson-generated_src_FormattedStreamWriter.c.o -Wl,--as-needed -Wl,--no-undefined -Wl,--start-group /usr/lib/x86_64-linux-gnu/libX11.so /usr/lib/x86_64-linux-gnu/libglib-2.0.so /usr/lib/x86_64-linux-gnu/libgtk-3.so /usr/lib/x86_64-linux-gnu/libgdk-3.so /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so /usr/lib/x86_64-linux-gnu/libpango-1.0.so /usr/lib/x86_64-linux-gnu/libharfbuzz.so /usr/lib/x86_64-linux-gnu/libatk-1.0.so /usr/lib/x86_64-linux-gnu/libcairo-gobject.so /usr/lib/x86_64-linux-gnu/libcairo.so /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so /usr/lib/x86_64-linux-gnu/libgio-2.0.so /usr/lib/x86_64-linux-gnu/libgobject-2.0.so -Wl,--end-group
    // |  /usr/bin/ld: xdump.p/meson-generated_src_AttributesPage.c.o: in function `attributes_page_on_update':
    // |  /home/miguelg/work/softgeist/xdump/build/../src/AttributesPage.vala:88: undefined reference to `window_attributes_copy'
    // |  collect2: error: ld returned 1 exit status
    public WindowAttributes window_attributes_copy (WindowAttributes attributes) {
        WindowAttributes copy = {
            attributes.x,
            attributes.y,
            attributes.width,
            attributes.height,
            attributes.border_width,
            attributes.depth,
            attributes.visual,
            attributes.root,
            attributes.@class,
            attributes.bit_gravity,
            attributes.win_gravity,
            attributes.backing_store,
            attributes.backing_planes,
            attributes.backing_pixel,
            attributes.save_under,
            attributes.colormap,
            attributes.map_installed,
            attributes.map_state,
            attributes.all_event_masks,
            attributes.your_event_mask,
            attributes.do_not_propagate_mask,
            attributes.override_redirect,
            attributes.screen,
        };
        return copy;
    }

    public struct WmHints {
        bool input;
        State initial_state;
        Pixmap icon_pixmap;
        Window icon_window;
        int icon_x;
        int icon_y;
        Pixmap icon_mask;
        Window window_group;
    }

    public struct WmSizeHints {
        Point position;
        Size size;
        Size min_size;
        Size max_size;
        Size inc_size;
        Point min_aspect;
        Point max_aspect;
        Size base_size;
        Gravity window_gravity;
    }

    public struct WmState {
        State state;
        Window icon;
    }

    public class StringMapping {
        public class BackingStoreType {
            public static string to_string (X.BackingStore backing_store) {
                switch (backing_store) {
                case X.BackingStore.NotUseful:
                    return "Not Useful";
                case X.BackingStore.WhenMapped:
                    return "When Mapped";
                case X.BackingStore.Always:
                    return "Always";
                default:
                    return "<unknown>";
                }
            }
        }

        public class GravityType {
            public static string to_string (Gravity gravity) {
                switch (gravity) {
                case Gravity.Forget:
                    return "Forget";
                case Gravity.NorthWest:
                    return "NorthWest";
                case Gravity.North:
                    return "North";
                case Gravity.NorthEast:
                    return "NorthEast";
                case Gravity.West:
                    return "West";
                case Gravity.Center:
                    return "Center";
                case Gravity.East:
                    return "East";
                case Gravity.SouthWest:
                    return "SouthWest";
                case Gravity.South:
                    return "South";
                case Gravity.SouthEast:
                    return "SouthEast";
                case Gravity.Static:
                    return "Static";
                default:
                    return "<unknown>";
                }
            }
        }

        public class MapStateType {
            public static string to_string (MapStateAttr map_state) {
                switch (map_state) {
                case X.MapStateAttr.IsUnmapped:
                    return "Unmapped";
                case X.MapStateAttr.IsUnviewable:
                    return "Unviewable";
                case X.MapStateAttr.IsViewable:
                    return "Viewable";
                default:
                    return "<unknown>";
                }
            }
        }

        public class WindowClassType {
            public static string to_string (X.WindowClass @class) {
                switch (@class) {
                case WindowClass.INPUT_ONLY:
                    return "Input";

                case WindowClass.INPUT_OUTPUT:
                    return "Input/Output";

                default:
                    return "<unknown>";
                }
            }
        }

        public class StateType {
            public static string to_string (X.State state) {
                switch (state) {
                case State.Withdrawn:
                    return "Withdrawn";

                case State.Normal:
                    return "Normal";

                case State.Iconic:
                    return "Iconic";

                case State.Inactive:
                    return "Inactive";

                default:
                    return "<unknown>";
                }
            }
        }

        public class EventMask {
            public static string[] event_mask_names;

            public static string[] to_string_array (long event_mask) {
                if (event_mask < 1) {
                    return {};
                }

                if (event_mask_names.length < 1) {
                    event_mask_names = {
                        "KeyPress",
                        "KeyRelease",
                        "ButtonPress",
                        "ButtonRelease",
                        "EnterWindow",
                        "LeaveWindow",
                        "PointerMotion",
                        "PointerMotionHint",
                        "Button1Motion",
                        "Button2Motion",
                        "Button3Motion",
                        "Button4Motion",
                        "Button5Motion",
                        "ButtonMotion",
                        "KeymapState",
                        "Exposure",
                        "VisibilityChange",
                        "StructureNotify",
                        "ResizeRedirect",
                        "SubstructureNotify",
                        "SubstructureRedirect",
                        "FocusChange",
                        "PropertyChange",
                        "ColormapChange",
                        "OwnerGrabButtonMas"
                    };
                }

                long mask = event_mask;
                int found_events = 0;
                for (var i = 0; mask > 0 && i < event_mask_names.length; ++i) {
                    if ((mask & 1) > 0) {
                        ++found_events;
                    }
                    mask >>= 1;
                }

                mask = event_mask;
                string[] events = new string[found_events];
                int j = 0;
                for (var i = 0; mask > 0 && i < event_mask_names.length; ++i) {
                    if ((mask & 1) > 0) {
                        assert (j < found_events);
                        events[j++] = event_mask_names[i];
                    }

                    mask >>= 1;
                }

                return events;
            }
        }
    }
}