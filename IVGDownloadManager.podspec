#
# Be sure to run `pod spec lint IVGDownloadManager.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "IVGDownloadManager"
  s.version      = "1.0.0"
  s.summary      = "Handle simple file updates from a server in the background."
  s.homepage     = "http://github.com/ivygulch/IVGDownloadManager"
  s.license      = 'MIT'
  s.author       = { "dwsjoquist" => "dwsjoquist@sunetos.com"}
  s.source       = { :git => "https://github.com/ivygulch/IVGDownloadManager.git", :tag => 'v1.0.0' }
  s.platform     = :ios, '5.0'
  s.source_files = 'IVGDownloadManager/LibClasses'
  s.frameworks = 'CFNetwork', 'Foundation','UIKit','CoreGraphics'
  s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'
end
