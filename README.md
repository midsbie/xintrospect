# XIntrospect

XIntrospect is a lightweight utility built with Vala and GTK3 for inspecting X11 window properties.

## Motivation

The inspiration behind XIntrospect stemmed from my desire to explore Vala and GTK3. I wanted to
challenge myself with a project that was both practical and enjoyable and the idea of creating a
tool to introspect X11 window properties seemed like the perfect fit.

## Features

- Inspect properties of the active window or any window selected by the user.
- Provides detailed information such as position, size, class, hints, and more.
- User-friendly interface with GTK3.

## Getting Started

### Prerequisites

Ensure you have the following dependencies installed:

- meson
- ninja
- x11
- glib-2.0
- gtk+-3.0
- gdk-x11-3.0

### Installation

1. Clone the repository:

        git clone git@github.com:midsbie/xintrospect.git
   
1. Navigate to the project directory and set up the build environment:

        cd xintrospect
        meson build
   
1. Build the project:

        ninja -C build

### Usage

1. Run the application:

        build/XIntrospect
   
1. The program will automatically select the active window upon launch.
1. To introspect another window, click the New Window button (leftmost) in the header bar and then
   click on the desired window.
1. Alternatively, use the Window Selector button in the header bar to choose a window from the list.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and
create. All contributions are greatly appreciated.

## License

Distributed under the MIT License. See LICENSE for more information.
