#
# Be sure to run `pod lib lint RxSwiftDitto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxSwiftDitto'
  s.version          = '1.0.0'
  s.summary = "RxSwift extension methods around the DittoSwift library."
  s.homepage         = 'https://github.com/getditto/RxSwiftDitto'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mbalex99' => 'max@ditto.live' }
  s.source           = { :git => 'https://github.com/getditto/RxSwiftDitto.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dittolive'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.1'

  s.source_files = 'RxSwiftDitto/Classes/**/*'

  # DittoSwift isn't available for all simulator types 
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  # s.resource_bundles = {
  #   'RxSwiftDitto' => ['RxSwiftDitto/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '>= 6.0.0'
  s.dependency 'DittoSwift', '>= 1.0.14'
end
