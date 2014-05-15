# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project/template/osx'
require 'motion-cocoapods'
require 'afmotion'
require 'bubble-wrap'
require 'bubble-wrap/reactor'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'deflow'
  app.info_plist['LSUIElement'] = true

  # Coacoapods
  app.pods do
    pod "IGHTMLQuery", "~> 0.7.1"
  end

end
