using X;

public enum ExtraAtomType {
    UTF8_STRING = 10000,
    WM_COLORMAP_WINDOWS,
    WM_PROTOCOLS,
    _NET_WM_ICON,
    WM_STATE,
}

public struct ExtraAtomTypeInfo {
    ExtraAtomType type;
    string name;
}

public class ExtraAtomTypes {
    GLib.HashTable<uint?, uint?> typing_map;

    static ExtraAtomTypeInfo[] extra_atom_types = {
        { ExtraAtomType.UTF8_STRING, "UTF8_STRING" },
        { ExtraAtomType.WM_COLORMAP_WINDOWS, "WM_COLORMAP_WINDOWS" },
        { ExtraAtomType.WM_PROTOCOLS, "WM_PROTOCOLS" },
        { ExtraAtomType._NET_WM_ICON, "_NET_WM_ICON" },
        { ExtraAtomType.WM_STATE, "WM_STATE" },
    };

    public ExtraAtomTypes(X.Display display) {
        typing_map = new GLib.HashTable<uint?, uint?> (GLib.int_hash, GLib.int_equal);

        foreach (var info in extra_atom_types) {
            var atom = display.intern_atom(info.name, true);
            if (atom == X.None) {
                continue;
            }

            typing_map.insert((uint) atom, (uint) info.type);
            /* stdout.printf("Mapped %s atom: %u -> %u\n", info.name, (uint) atom, info.type); */
        }
    }

    public X.Atom? get(X.Atom actual_type) {
        return typing_map.lookup((uint) actual_type);
    }
}