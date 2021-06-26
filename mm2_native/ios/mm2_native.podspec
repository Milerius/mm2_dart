#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mm2_native.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mm2_native'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin for atomicdex api (mm2).'
  s.description      = <<-DESC
A flutter plugin for atomicdex api (mm2)
                       DESC
  s.homepage         = 'https://atomicdex.io/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes**/*.h'
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
