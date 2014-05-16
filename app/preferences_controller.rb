class PreferencesController < NSWindowController

  attr_reader :window

  def window
    @window ||= Proc.new do
      w = NSWindow.alloc.initWithContentRect([[240, 180], [432, 295]],
        styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
        backing: NSBackingStoreBuffered,
        defer: false)
      w.title = "Preferences"
      w.setMinSize(NSMakeSize(432, 261))
      w
    end.call
  end

  def init
    super
    window.orderFrontRegardless
    setup
    self
  end

  def setup
    @textField = NSTextField.alloc.initWithFrame([[90, 120], [100, 22]])
    @textField.stringValue = '5'
    @textField.alignment = NSCenterTextAlignment
    @textField.bezelStyle = NSTextFieldRoundedBezel
    @textField.target = self # THIS LINE
    @textField.action = 'takeFloatValueForVolumeFrom:' # THIS LINE
    window.contentView.addSubview(@textField)

    @button = NSButton.alloc.initWithFrame([[90, 20], [100, 22]])
    @button.title = 'Mute'
    @button.bezelStyle = NSTexturedRoundedBezelStyle
    @button.target = self # THIS LINE
    @button.action = 'mute' # THIS LINE
    window.contentView.addSubview(@button)
  end

  def mute
    NSLog('Mute was pressed')
  end

end