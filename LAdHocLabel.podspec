Pod::Spec.new do |s|
  s.name         = "LAdHocLabel"
  s.version      = "1.0"
  s.summary      = "LAdHocLabel"
  s.platform     = :ios, '6.0'
  s.homepage     = "https://github.com/lukagabric/LAdHocLabel"
  s.source       = { :git => 'https://github.com/lukagabric/LAdHocLabel'}
  s.source_files = 'LAdHocLabel/LAdHocLabel/Classes/Core/LAdHocLabel/*.{h,m}'
  s.requires_arc = true
end