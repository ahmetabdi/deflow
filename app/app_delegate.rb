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

    createStorageFolder
    saveImage("https://www.google.co.uk/logos/doodles/2014/dorothy-hodgkins-104th-birthday-born-1910-5134139112030208.3-hp.jpg")
    deleteAllFiles
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

  def createStorageFolder
    docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first

    directory = docDir.stringByAppendingPathComponent("Deflow")

    fileManager = NSFileManager.defaultManager
    if(!fileManager.createDirectoryAtPath(directory, withIntermediateDirectories:true, attributes: nil, error: nil))
      NSLog("Error: Create folder failed: %@", directory)
    else
      NSLog("Successfully created folder: %@", directory)
    end
  end

  def saveImage(imgURL)
    documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    imgName = "Deflow/image.png"
    fileManager = NSFileManager.defaultManager
    writablePath = documentsDirectoryPath.stringByAppendingPathComponent(imgName)

    if(!fileManager.fileExistsAtPath(writablePath))
        NSLog("%@ doesn't exist creating...", imgName);
        data = NSData.dataWithContentsOfURL(NSURL.URLWithString(imgURL))

        error = nil
        data.writeToFile(documentsDirectoryPath.stringByAppendingPathComponent(
                                    NSString.stringWithFormat("%@", imgName)),
                                    options:NSAtomicWrite, error: error)

      if (error)
        NSLog("Error Writing File: %@", error);
      else
        NSLog("%@ Saved SuccessFully", imgName);
      end
    else
      NSLog("%@ already exists skipping...", imgName)
    end
  end

  def deleteAllFiles
    fm = NSFileManager.defaultManager

    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("Deflow")
    fm.contentsOfDirectoryAtPath(directory, error: nil).each do |file|
        success = fm.removeItemAtPath(NSString.stringWithFormat("%@/%@", directory, file), error: nil)
        if !success
          NSLog("Failed to delete file: #{file}")
        else
          NSLog("Successfully deleted file: #{file}")
        end
    end
  end

end
