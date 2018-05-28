Pod::Spec.new do |spec|
  spec.name = 'TinyComponent'
  spec.version = '0.1.3'
  spec.license = 'MIT'
  spec.summary = 'Component-based Architecture: Making view composition fun and easy.'
  spec.homepage = 'https://github.com/royhsu/tiny-component'
  spec.authors = { 'Roy Hsu' => 'roy.hsu@tinyworld.cc' }
  spec.source = { :git => 'https://github.com/royhsu/tiny-component.git', :tag => spec.version }
  spec.framework = 'Foundation'
  spec.source_files = 'Sources/*.swift'
  spec.ios.deployment_target = '11.0'
  spec.ios.source_files = 'Sources/iOS/*.swift'
  spec.ios.framework = 'UIKit'
  spec.swift_version = '4.1'
end
