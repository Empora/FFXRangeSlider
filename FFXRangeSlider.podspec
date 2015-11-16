Pod::Spec.new do |s|
    s.name         = 'FFXRangeSlider'
    s.version      = '0.4'
    s.license      = { :type => 'MIT' }
    s.homepage     = 'https://github.com/empora/FFXRangeSlider'
    s.authors      = { 'Robert Biehl' => 'robert.biehl@empora.com', 'Maksym Shcheglov' => 'maxscheglov@gmail.com' }
    s.summary      = 'iOS slider control that allows you to pick a minimum and maximum range, supports steps, and is highly configurable.'
    s.source       = { :git => "https://github.com/empora/FFXRangeSlider.git", :tag => s.version.to_s }
    s.platform     = :ios, '7.0'
    s.requires_arc = true
    s.source_files = 'FFXRangeSlider/**/*'
    s.public_header_files = 'FFXRangeSlider/**/*.h'
end