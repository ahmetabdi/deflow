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

    # sws = NSWorkspace.sharedWorkspace
    # # image = NSURL.fileURLWithPath("/Library/Desktop Pictures/Andromeda Galaxy.jpg")
    # image = NSURL.fileURLWithPath("http://upload.wikimedia.org/wikipedia/commons/b/b4/The_Sun_by_the_Atmospheric_Imaging_Assembly_of_NASA's_Solar_Dynamics_Observatory_-_20100819.jpg")

    # err = nil
    # for screen in NSScreen.screens do
    #     opt = sws.desktopImageOptionsForScreen(screen)
    #     sws.setDesktopImageURL(image, forScreen:screen, options:opt, error: err)
    #     if (err)
    #         NSLog("%@",err.localizedDescription)
    #     else
    #         scr = screen.deviceDescription.objectForKey("NSScreenNumber")
    #         NSLog("Set %@ for space %i on screen %@",image.path, self.spaceNumber,scr)
    #     end
    # end
    spaceNumber
  end

  def spaceNumber
    indowsInSpace = CGWindowListCopyWindowInfo(kCGWindowListOptionAll | kCGWindowListOptionOnScreenOnly, kCGNullWindowID)
    for thisWindow in windowsInSpace do
      puts thisWindow
    end
    return -1
  end


  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

end
