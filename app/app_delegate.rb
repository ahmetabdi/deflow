class AppDelegate

  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']
    @status_menu = NSMenu.new

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setMenu(@status_menu)
    @status_item.setHighlightMode(true)
    @status_item.setTitle('Test')
    @status_menu.addItem createMenuItem('Quit', 'terminate:')

    path = NSURL.fileURLWithPath (NSBundle.mainBundle.pathForResource("123", ofType:"jpg"))

    NSWorkspace.sharedWorkspace.setDesktopImageURL(path, forScreen: NSScreen.screens.lastObject, options: nil, error: nil)
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

end
