namespace X {
    [CCode(cname = "XCreateFontCursor")]
    public int create_font_cursor(Display display, uint shape);

    [CCode(cname = "XSync")]
    public int sync(Display display, bool discard);
}