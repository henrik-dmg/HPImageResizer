Pod::Spec.new do |s|

  s.name         = "HPImageResizer"
  s.version      = "1.0.0"
  s.summary      = "A lightweight and high-performant package to resize and scale image on iOS and macOS"

  s.homepage     = "https://panhans.dev/opensource/hpimageresizer"

  s.license      = "MIT"

  s.author             = { "Henrik Panhans" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.14"

  s.source       = { :git => "https://github.com/henrik-dmg/HPImageResizer.git", :tag => s.version }

  s.source_files  = "Sources/HPImageResizer/**/*.swift"

  s.framework = "Foundation"
  s.ios.framework = "ImageIO"
  s.osx.framework = "ImageIO"

  s.swift_version = "5.1"
  s.requires_arc = true

end
