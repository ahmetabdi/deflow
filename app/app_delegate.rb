class AppDelegate

  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']
    @status_menu = NSMenu.new

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setMenu(@status_menu)
    @status_item.setHighlightMode(true)
    @status_item.setTitle('Deflow')

    @status_menu.addItem createMenuItem('Force new wallpaper', 'getWallpaper')

    NSScreen.screens.each_with_index do |screen, index|
      @status_menu.addItem createMenuItem("Use screen #{index}", "setScreen:")
    end
    @status_menu.addItem createMenuItem('Quit', 'terminate:')

    @config = NSUserDefaults.standardUserDefaults
    @config['current_image'] ||= "#{random}.png"

    NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: 'timerGo', userInfo: nil, repeats: true)
  end

  def setScreen(number)
    puts "Setting screen #{number}"
  end

  def random
    range = [*'0'..'9', *'a'..'z', *'A'..'Z']
    return Array.new(8){range.sample}.join
  end

  def timerGo
    createStorageFolder
    deleteAllFiles
    getWallpaper
  end

  def getWallpaper
    random = Random.new
    AFMotion::HTTP.get("http://wall.alphacoders.com/api1.0/get.php?auth=23a6f2db69037bdf11a989b02b9c43e3&page=#{random.rand(0..99)}&category_id=32") do |result|
      result_data = BW::JSON.parse("#{result.body}")
      image_url = result_data["wallpapers"][random.rand(0..25)]['url']
      saveImage(image_url)
    end
  end

  def setWallpaper
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    path = NSURL.fileURLWithPath(directory.stringByAppendingPathComponent(NSString.stringWithFormat("%@", @config['current_image'])))
    EM.schedule_on_main do
      NSWorkspace.sharedWorkspace.setDesktopImageURL(path, forScreen: NSScreen.screens.lastObject, options: nil, error: nil)
    end
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def toggle(object)
    object.setState NSOffState
    object.setState NSOnState
  end

  def createStorageFolder
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")

    fileManager = NSFileManager.defaultManager

    fileExists = fileManager.fileExistsAtPath(directory)
    if (fileExists)
        NSLog("Folder already exists...")
    else
      if(!fileManager.createDirectoryAtPath(directory, withIntermediateDirectories:true, attributes: nil, error: nil))
        NSLog("Error: Create folder failed: %@", directory)
      else
        NSLog("Successfully created folder: %@", directory)
      end
    end
  end

  def saveImage(imgURL)
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    @config['current_image'] = "#{random}.png"
    imgName = @config['current_image']
    fileManager = NSFileManager.defaultManager
    writablePath = directory.stringByAppendingPathComponent(imgName)

    if(!fileManager.fileExistsAtPath(writablePath))
        data = NSData.dataWithContentsOfURL(NSURL.URLWithString(imgURL))

        error = nil
        data.writeToFile(directory.stringByAppendingPathComponent(
                                    NSString.stringWithFormat("%@", imgName)),
                                    options:NSAtomicWrite, error: error)

      if (error)
        NSLog("Error Writing File: %@", error)
      else
        NSLog("%@ Saved SuccessFully", imgName)
        setWallpaper
      end
    else
      NSLog("%@ already exists skipping...", imgName)
    end
  end

  def deleteAllFiles
    fm = NSFileManager.defaultManager
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    fm.contentsOfDirectoryAtPath(directory, error: nil).each do |file|
        success = fm.removeItemAtPath(NSString.stringWithFormat("%@/%@", directory, file), error: nil)
        if success
          NSLog("Successfully deleted file: #{file}")
        else
          NSLog("Failed to delete file: #{file}")
        end
    end
  end

end
