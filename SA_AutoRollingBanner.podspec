Pod::Spec.new do |s|
  s.name             = "SA_AutoRollingBanner"
  s.version          = "0.1.2"
  s.summary          = "A banner view which scrolls automatically."
  s.description      = <<-DESC
                        A banner view which scrolls automatically like taobao headline. 
                       DESC
  s.homepage         = "https://github.com/sealedace/SA_AutoRollingBanner"
  s.license          = 'MIT'
  s.author           = { "sealedace" => "sealedaceg@gmail.com" }
  s.source           = { :git => "https://github.com/sealedace/SA_AutoRollingBanner.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/SealedAce'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'SA_AutoRollingBanner/SA_AutoRollingBanner/SA_AutoRollingBanner/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'

end
