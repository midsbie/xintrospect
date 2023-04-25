using Gtk;
using Gdk;
using X;
using GLib;

public struct ProgramOptions {
    string? window_xid;
    bool attrs;
    bool children;
}

public enum ParseResult {
    Error,
    Ok,
    None,
}

public class ApplicationCli {
    ProgramOptions options;
    X.Display display;
    X.Window root_window;
    FormattedStreamWriter writer = new FormattedStreamWriter(stdout);

    public static ParseResult parse_program_options(string[] args, out ProgramOptions options) {
        options = {};

        OptionEntry[] entries = {
            { "attrs", 0, OptionFlags.NONE, OptionArg.NONE, ((void*) &options.attrs), "List window attributes (default false)", null },
            { "children", 0, OptionFlags.NONE, OptionArg.NONE, ((void*) &options.children), "List child windows (default: false)", null },
            { "id", 0, OptionFlags.NONE, OptionArg.STRING, ((void*) &options.window_xid), "Window XID identifier (default: root window)" },
            { null }
        };

        var context = new OptionContext("xintrospect");
        context.add_main_entries(entries, null);

        try {
            context.parse(ref args);
        } catch (OptionError e) {
            stderr.printf("%s\n", e.message);
            return ParseResult.Error;
        }

        if (!options.attrs && !options.children) {
            return ParseResult.None;
        }

        return ParseResult.Ok;
    }

    public ApplicationCli(ProgramOptions options) {
        this.options = options;
        display = new X.Display();
        root_window = display.default_root_window();
    }

    public int run() {
        X.Window window;

        if (options.window_xid == null || options.window_xid.length < 1) {
            window = root_window;
        } else if (options.window_xid.scanf("0x%lx", out window) != 1) {
            if (options.window_xid.scanf("%ld", out window) != 1) {
                stderr.printf("Invalid window ID (%s)\n", options.window_xid);
                return 1;
            }
        }

        if (options.children) {
            var count = list_window_children(window);
            if (count < 1) {
                stdout.printf("No child windows found for %s\n", format_number((long) window));
            }
        } else if (options.attrs) {
            list_window_attributes(window);
        }


        return 0;
    }

    public int list_window_children(X.Window from_window) {
        EnumeratedXWindowHierarchy enumerated_windows;
        enumerated_windows = new XWindowEnumerator(display).get_hierarchy(from_window);

        print_window(&enumerated_windows, 0);
        return print_children(&enumerated_windows);
    }

    private void print_window(EnumeratedXWindowHierarchy* enumerated_window, int index) {
        writer.indented_printf("%03d: 0x%lx (%lu): %s\n",
                               index, (ulong) enumerated_window->window,
                               (ulong) enumerated_window->window,
                               enumerated_window->name ?? "<no name>"
        );

        if (options.attrs) {
            writer.incr_indentation_level();
            list_window_attributes(enumerated_window->window);
            writer.decr_indentation_level();
        }
    }

    private int print_children(EnumeratedXWindowHierarchy* enumerated_window) {
        writer.incr_indentation_level();

        var i = 0, count = 0;
        foreach (var child in enumerated_window.children) {
            ++count;
            print_window(&child, i++);
            count += print_children(&child);
        }

        writer.decr_indentation_level();
        return count;
    }

    public X.WindowAttributes list_window_attributes(X.Window win) {
        X.WindowAttributes window_attributes;
        display.get_window_attributes(win, out window_attributes);

        writer.indented_printf("* Window attributes for window 0x%lx (%lu):\n",
                               (uint) win, (uint) win);
        writer.incr_indentation_level();
        writer.indented_printf("Position: (x=%d, y=%d)\n", window_attributes.x, window_attributes.y);
        writer.indented_printf("Dimensions: (width=%d, height=%d)\n", window_attributes.width, window_attributes.height);
        writer.indented_printf("Geometry: (%d, %d):(%d, %d)\n",
                               window_attributes.x, window_attributes.y,
                               window_attributes.x + window_attributes.width,
                               window_attributes.y + window_attributes.height);
        writer.indented_printf("Border width: %d\n", window_attributes.border_width);
        writer.indented_printf("Depth: %d\n", window_attributes.depth);
        writer.indented_printf("Visual: 0x%x\n", (uint) window_attributes.visual.get_visual_id());
        writer.indented_printf("Root window: 0x%lx (%lu)\n",
                               (uint) window_attributes.root,
                               (uint) window_attributes.root);
        writer.indented_printf("Class: %s (0x%x)\n",
                               ((X.WindowClass) window_attributes.class).to_string(),
                               window_attributes.class);
        writer.indented_printf("Bit gravity: %s (0x%d)\n",
                               ((X.Gravity) window_attributes.bit_gravity).to_string(),
                               window_attributes.bit_gravity);
        writer.indented_printf("Window gravity: %s (0x%x)\n",
                               ((X.Gravity) window_attributes.win_gravity).to_string(),
                               window_attributes.win_gravity);
        writer.indented_printf("Backing store: %d\n", window_attributes.backing_store);
        writer.indented_printf("Backing planes: 0x%lx\n", window_attributes.backing_planes);
        writer.indented_printf("Backing pixel: %lx\n", window_attributes.backing_pixel);
        // writer.indented_printf("save_under: %d\n", window_attributes.save_under);
        writer.indented_printf("colormap: 0x%x\n", (uint) window_attributes.colormap);
        // writer.indented_printf("map_installed: %d\n", window_attributes.map_installed);
        writer.indented_printf("Map state: %s (0x%x)\n",
                               ((X.MapStateAttr) window_attributes.map_state).to_string(),
                               window_attributes.map_state);
        writer.indented_printf("All event masks: 0x%lx\n", window_attributes.all_event_masks);
        writer.indented_printf("Your event mask: 0x%lx\n", window_attributes.your_event_mask);
        writer.indented_printf("Do not propagate mask: 0x%lx\n", window_attributes.do_not_propagate_mask);
        writer.decr_indentation_level();
        writer.printf("\n");

        return window_attributes;
    }

    private string format_number(long value) {
        return "0x%lx (%lu)".printf(value, value);
    }
}