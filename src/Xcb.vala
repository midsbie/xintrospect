namespace Xcb {
    public class DesktopLayout {
        public Orientation orientation;
        public int columns;
        public int rows;
        public StartingCorner starting_corner;

        public DesktopLayout (Orientation orientation, int columns, int rows,
            StartingCorner starting_corner) {
            this.orientation = orientation;
            this.columns = columns;
            this.rows = rows;
            this.starting_corner = starting_corner;
        }

        public class Orientation {
            public enum Type {
                Horizontal = 0,
                Vertical = 1,
            }

            Type orientation;

            public static GLib.HashTable<int?, string?> enum_string_mapping;

            static construct {
                enum_string_mapping = new GLib.HashTable<int?, string?> (GLib.int_hash, GLib.int_equal);
                enum_string_mapping.insert (Type.Horizontal, "Horizontal");
                enum_string_mapping.insert (Type.Vertical, "Verical");
            }

            public Orientation (Type orientation) {
                this.orientation = orientation;
            }

            public Type get () {
                return orientation;
            }

            public string to_string () {
                return enum_string_mapping.lookup (orientation) ?? "<unknown>";
            }
        }

        public class StartingCorner {
            public enum Type {
                TOP_LEFT = 0,
                TOP_RIGHT = 1,
                BOTTOM_RIGHT = 2,
                BOTTOM_LEFT = 3,
            }

            Type starting_corner;

            public static GLib.HashTable<int?, string?> enum_string_mapping;

            static construct {
                enum_string_mapping = new GLib.HashTable<int?, string?> (GLib.int_hash, GLib.int_equal);
                enum_string_mapping.insert (Type.TOP_LEFT, "Top left");
                enum_string_mapping.insert (Type.TOP_RIGHT, "Top right");
                enum_string_mapping.insert (Type.BOTTOM_RIGHT, "Bottom right");
                enum_string_mapping.insert (Type.BOTTOM_LEFT, "Bottom left");
            }

            public StartingCorner (Type starting_corner) {
                this.starting_corner = starting_corner;
            }

            public Type get () {
                return starting_corner;
            }

            public string to_string () {
                return enum_string_mapping.lookup (starting_corner) ?? "<unknown>";
            }
        }
    }
}