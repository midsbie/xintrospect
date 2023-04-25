project('xdump', 'vala')

sources = files(
  # Application
  'src/main.vala',
  'src/ApplicationCli.vala',
  'src/ApplicationGui.vala',
  # UI
  # -- Main window
  'src/MainWindow.vala',
  'src/HeaderBar.vala',
  'src/ApplicationMenu.vala',
  'src/ApplicationAboutDialog.vala',
  # -- Views
  'src/MainPaneView.vala',
  'src/WindowTreeView.vala',
  'src/WindowParentsTreeView.vala',
  'src/WindowHierarchyTreeView.vala',
  'src/WindowSelectorDialog.vala',
  'src/View.vala',
  'src/AttributesView.vala',
  'src/PropertiesView.vala',
  # Utilities
  'src/ApplicationEventBus.vala',
  'src/EmptyViewWidget.vala',
  'src/TreeViewBuilder.vala',
  'src/XWindowPropertyWidgetFactory.vala',
  'src/WidgetFactory.vala',
  'src/Consts.vala',
  # -- X
  'src/ExtraAtomTypes.vala',
  'src/FormattedStreamWriter.vala',
  'src/LiveWindowSelector.vala',
  'src/XWindowEnumerator.vala',
  'src/XWindowPropertyEnumerator.vala',
  'src/XWindowPropertyReader.vala',
  'src/XWindowPropertyStringRenderer.vala',
  'src/X11.vala',
  'src/X11Util.vala',
  'src/Xcb.vala',
  # VAPI
  'src/x11.vapi'
)

dependencies = [
  dependency('x11'),
  dependency('glib-2.0'),
  dependency('gtk+-3.0'),
  dependency('gdk-x11-3.0')
]

executable('xdump', sources, dependencies: dependencies)
