class AppDelegate

  attr_accessor :menu
  attr_accessor :categories_menu
  attr_accessor :screen_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']
    @menu = NSMenu.new

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setMenu(@menu)
    @status_item.setHighlightMode(true)

    img = NSImage.imageNamed('status18x18')
    @status_item.setImage(img)
    build_menu(@menu)
    config

    NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: 'timerGo', userInfo: nil, repeats: true)
  end

  def config
    @config = NSUserDefaults.standardUserDefaults
    @config['current_image'] ||= "#{Helper.random}.png"
    @config['current_category'] ||= 32
    @config['current_screen'] ||= 0

    @categories_menu.itemArray.each do |item|
      item.setState NSOnState if item.tag == @config['current_category']
    end

    @screen_menu.itemArray.each do |item|
      item.setState NSOnState if item.tag == @config['current_screen']
    end
  end

  def build_menu(menu)
    # -------------------------------------------------------------------- #
    menu.addItem createMenuItem('Force new wallpaper', 'getWallpaper')
    # -------------------------------------------------------------------- #
    menu.addItem NSMenuItem.separatorItem
    build_submenu
    menu.addItem NSMenuItem.separatorItem
    # -------------------------------------------------------------------- #
    menu.addItem createMenuItem('Preferenecs', 'test:')
    menu.addItem createMenuItem('Quit', 'terminate:')
    # -------------------------------------------------------------------- #
  end

  def build_submenu
    @categories_menu = NSMenu.new
    @screen_menu = NSMenu.new

    mi = NSMenuItem.new
    mi.title = 'Categories'
    mi.setSubmenu(@categories_menu)
    @menu.addItem mi

    Helper.categories.each do |k,v|
      mi = NSMenuItem.new
      mi.title = "#{k}"
      mi.tag = v
      mi.action = 'setCategory:'
      @categories_menu.addItem mi
    end

    mi = NSMenuItem.new
    mi.title = 'Screen'
    mi.setSubmenu(@screen_menu)
    @menu.addItem mi

    NSScreen.screens.each_with_index do |screen, index|
      mi = NSMenuItem.new
      mi.title = "Screen: #{index}"
      mi.tag = index
      mi.action = 'setScreen:'
      @screen_menu.addItem mi
    end
  end

  def setCategory(sender)
    @config['current_category'] = sender.tag
    @categories_menu.itemArray.each do |item|
      item.setState NSOffState
    end
    sender.setState NSOnState
  end

  def build_preferences(sender)
    @preferences ||= PreferencesController.new
    @preferences.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def setScreen(sender)
    @config['current_screen'] = sender.tag
    @screen_menu.itemArray.each do |item|
      item.setState NSOffState
    end
    sender.setState NSOnState
  end


  def timerGo
    createStorageFolder
    deleteAllFiles
    getWallpaper
  end

  def getWallpaper
    random = Random.new
    AFMotion::HTTP.get("http://wall.alphacoders.com/api1.0/get.php?auth=23a6f2db69037bdf11a989b02b9c43e3&page=#{random.rand(0..20)}&category_id=#{@config['current_category']}") do |result|
      begin
        result_data = BW::JSON.parse("#{result.body}")
        image_url = result_data["wallpapers"][random.rand(0..25)]['url']
        saveImage(image_url)
      rescue Exception => e
        puts e.message
      end
    end
  end

  def setWallpaper
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    path = NSURL.fileURLWithPath(directory.stringByAppendingPathComponent(NSString.stringWithFormat("%@", @config['current_image'])))
    EM.schedule_on_main do
      NSWorkspace.sharedWorkspace.setDesktopImageURL(path, forScreen: NSScreen.screens[@config['current_screen']], options: nil, error: nil)
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
      NSLog("Folder already exists")
    else
      if(!fileManager.createDirectoryAtPath(directory, withIntermediateDirectories:true, attributes: nil, error: nil))
        NSLog("Failed to create folder")
      else
        NSLog("Successfully created folder")
      end
    end
  end

  def saveImage(imgURL)
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    @config['current_image'] = "#{Helper.random}.png"
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
        NSLog("Error writing file")
      else
        NSLog("Saved Successfully")
        setWallpaper
      end
    else
      NSLog("File already exists, skipping...")
    end
  end

  def deleteAllFiles
    fm = NSFileManager.defaultManager
    directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
    directory = directory.stringByAppendingPathComponent("deflow")
    fm.contentsOfDirectoryAtPath(directory, error: nil).each do |file|
      success = fm.removeItemAtPath(NSString.stringWithFormat("%@/%@", directory, file), error: nil)
      if success
        NSLog("File deleted")
      else
        NSLog("Failed to delete")
      end
    end
  end

end
