Pod::Spec.new do |s|
  s.name         = "XFUtils"
  s.version      = "0.0.1"
  s.summary      = "Utility methods used in XForge projects"

  s.description  = <<-DESC
		   This project provides commonly used classes & methods from projects we made.

                   * Some networking helpers, like a lightweight implementation of futures and promises
                   * Creating and modifying UIImages from different sources
                   * Core Data helpers
		   * Runtime functions 
                   DESC

  s.homepage     = "https://github.com/xforge-at/XFUtils"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "XForge Software Development GmbH" => "contact@xforge.at" }
  s.social_media_url   = "http://twitter.com/xforge-at"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/xforge-at/XFUtils.git", :commit => "49a542fd1823da8f5e3eb22317e2ac92f84aeff2" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
