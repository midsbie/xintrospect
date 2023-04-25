using Gtk;
using Gdk;
using X;
using GLib;

int main(string[] args) {
    ProgramOptions options;
    switch (ApplicationCli.parse_program_options(args, out options)) {
    case ParseResult.Ok:
        return new ApplicationCli(options).run();

    case ParseResult.None:
        return new ApplicationGui().run(args);

    case ParseResult.Error:
        return -1;

    default:
        return ~0;
    }
}