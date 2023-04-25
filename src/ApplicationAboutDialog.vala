using Gtk;

class ApplicationAboutDialog : Gtk.AboutDialog {
    public ApplicationAboutDialog () {
        program_name = PROGRAM_NAME;
        logo_icon_name = "window-new";
        version = VERSION;
        authors = { "Miguel Guedes <miguel.a.guedes@gmail.com>" };
        license_type = Gtk.License.GPL_3_0;
    }
}