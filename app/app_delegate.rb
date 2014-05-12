class AppDelegate

  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']
    @status_menu = NSMenu.new

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setMenu(@status_menu)
    @status_item.setHighlightMode(true)
    @status_item.setTitle('Test')

    @status_menu.addItem createMenuItem('Force new wallpaper', 'force')
    @status_menu.addItem createMenuItem('Quit', 'terminate:')

    # path = NSURL.fileURLWithPath (NSBundle.mainBundle.pathForResource("123", ofType:"jpg"))

    # NSWorkspace.sharedWorkspace.setDesktopImageURL(path, forScreen: NSScreen.screens.lastObject, options: nil, error: nil)

    saveImagesInLocalDirectory("https://www.google.co.uk/logos/doodles/2014/dorothy-hodgkins-104th-birthday-born-1910-5134139112030208.3-hp.jpg")
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def force
    # Force push a new wallpaper
  end

  def toggle(object)
    object.setState NSOffState
    object.setState NSOnState
  end

  def saveImagesInLocalDirectory(imgURL)
    documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    imgName = "image.png"
    fileManager = NSFileManager.defaultManager
    writablePath = documentsDirectoryPath.stringByAppendingPathComponent(imgName)

    if(!fileManager.fileExistsAtPath(writablePath))
        NSLog("file doesn't exist");
        # Save Image From URL
        data = NSData.dataWithContentsOfURL(NSURL.URLWithString(imgURL))

        error = nil
        data.writeToFile(documentsDirectoryPath.stringByAppendingPathComponent(NSString.stringWithFormat("%@", imgName)), options:NSAtomicWrite, error: error)

      if (error)
        NSLog("Error Writing File : %@",error);
      else
        NSLog("Image %@ Saved SuccessFully",imgName);
      end
    else
      NSLog("file exist");
    end
  end

end
