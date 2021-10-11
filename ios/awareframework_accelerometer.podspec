#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint awareframework_accelerometer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'awareframework_accelerometer'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://www.awareframework.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yuuki Nishiyama' => 'yuukin@iis.u-tokyo.ac.jp' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'com.awareframework.ios.sensor.accelerometer'
  s.dependency 'awareframework_core'
  # s.dependency 'com.awareframework.ios.sensor.core'
  s.platform = :ios, '10.0'
  s.ios.deployment_target  = '10.0'  

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  # IPHONEOS_DEPLOYMENT_TARGET
end
