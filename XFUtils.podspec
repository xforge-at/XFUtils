Pod::Spec.new do |s|
  s.name         = "XFUtils"
  s.version      = "0.1"
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
  s.source       = { :git => "https://github.com/xforge-at/XFUtils.git", :tag => "0.1" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
