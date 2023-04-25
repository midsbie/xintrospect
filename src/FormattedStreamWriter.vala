class FormattedStreamWriter {
    unowned FileStream stream;
    uint indentation_level = 0;

    public FormattedStreamWriter(FileStream stream) {
        this.stream = stream;
    }

    public void incr_indentation_level() {
        ++indentation_level;
    }

    public void decr_indentation_level() {
        if (indentation_level > 0) {
            --indentation_level;
        }
    }

    public void set_indentation_level(int level) {
        indentation_level = level;
    }

    public void indented_printf(string format, ...) {
        var args = va_list();
        indent();
        stream.vprintf(format, args);
    }

    public void printf(string format, ...) {
        var args = va_list();
        stream.vprintf(format, args);
    }

    private void indent() {
        for (var i = 0; i < indentation_level; ++i) {
            stream.printf("  ");
        }
    }
}