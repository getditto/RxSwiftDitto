Pod::Spec.new do |s|
  s.name             = 'RxSwiftDitto'
  s.version          = '1.0.1'
  s.summary          = "RxSwift extension methods around the DittoSwift library."
  s.homepage         = 'https://github.com/getditto/RxSwiftDitto'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'mbalex99' => 'max@ditto.live' }
  s.source           = { git: 'https://github.com/getditto/RxSwiftDitto.git', tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/dittolive'

  s.ios.deployment_target = '12.0'

  s.source_files = 'RxSwiftDitto/Classes/**/*'

  s.swift_versions = ['5.2', '5.3', '5.4', '5.5']

  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'DittoSwift', '~> 1.0'
end
