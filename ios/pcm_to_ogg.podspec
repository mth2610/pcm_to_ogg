#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pcm_to_ogg.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pcm_to_ogg'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  
  s.source_files = 'Classes/**/*', 
                   '../src/pcm_to_ogg.c',
                   '../src/third_party/libogg-1.3.5/src/bitwise.c',
                   '../src/third_party/libogg-1.3.5/src/framing.c',
                   '../src/third_party/libvorbis-1.3.7/lib/analysis.c',
                   '../src/third_party/libvorbis-1.3.7/lib/barkmel.c',
                   '../src/third_party/libvorbis-1.3.7/lib/bitrate.c',
                   '../src/third_party/libvorbis-1.3.7/lib/block.c',
                   '../src/third_party/libvorbis-1.3.7/lib/codebook.c',
                   '../src/third_party/libvorbis-1.3.7/lib/envelope.c',
                   '../src/third_party/libvorbis-1.3.7/lib/floor0.c',
                   '../src/third_party/libvorbis-1.3.7/lib/floor1.c',
                   '../src/third_party/libvorbis-1.3.7/lib/info.c',
                   '../src/third_party/libvorbis-1.3.7/lib/lookup.c',
                   '../src/third_party/libvorbis-1.3.7/lib/lpc.c',
                   '../src/third_party/libvorbis-1.3.7/lib/lsp.c',
                   '../src/third_party/libvorbis-1.3.7/lib/mapping0.c',
                   '../src/third_party/libvorbis-1.3.7/lib/mdct.c',
                   '../src/third_party/libvorbis-1.3.7/lib/psy.c',
                   '../src/third_party/libvorbis-1.3.7/lib/registry.c',
                   '../src/third_party/libvorbis-1.3.7/lib/res0.c',
                   '../src/third_party/libvorbis-1.3.7/lib/sharedbook.c',
                   '../src/third_party/libvorbis-1.3.7/lib/smallft.c',
                   '../src/third_party/libvorbis-1.3.7/lib/synthesis.c',
                   '../src/third_party/libvorbis-1.3.7/lib/tone.c',
                   '../src/third_party/libvorbis-1.3.7/lib/vorbisenc.c',
                   '../src/third_party/libvorbis-1.3.7/lib/vorbisfile.c',
                   '../src/third_party/libvorbis-1.3.7/lib/window.c'
  
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    # Header search paths for ogg and vorbis
    'HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/../src/third_party/libogg-1.3.5/include" "${PODS_TARGET_SRCROOT}/../src/third_party/libvorbis-1.3.7/include" "${PODS_TARGET_SRCROOT}/../src/third_party/libvorbis-1.3.7/lib"'
  }
  
  # Suppress warnings from the C libraries
  s.compiler_flags = '-Wno-everything'

  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'pcm_to_ogg_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
