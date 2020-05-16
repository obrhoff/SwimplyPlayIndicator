Pod::Spec.new do |s|
  s.name = "SwimplyPlayIndicator"
  s.version = "1.0.3"
  s.summary = "Animated PlayIndicator written in SwiftUI. Inspired by Apple's Music Player."
  s.homepage = "https://github.com/docterd/SwimplyPlayIndicator"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/SwimplyPlayIndicator.git", :tag => "1.0.3"}
  s.source_files = "Sources/SwimplyPlayIndicator/SwimplyPlayIndicator.swift"
  s.osx.deployment_target  = '10.15'
  s.osx.framework  = 'SwiftUI'
  s.ios.deployment_target = "13.0"
  s.ios.framework = 'SwiftUI'
  s.tvos.deployment_target = "13.0"
  s.tvos.framework = 'SwiftUI'
  s.watchos.deployment_target = "6.0"
  s.watchos.framework = 'SwiftUI'
  s.swift_version = '5.0'
end
