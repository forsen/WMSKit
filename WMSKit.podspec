Pod::Spec.new do |s|

  s.name         = "WMSKit"
  s.version      = "1.0.0"
  s.summary      = "A kit to consume WMS services"
  s.description  = <<-DESC
  This kit provide a class that will take a WMS Service URI and return an overlay to be used
  with MapKit
                   DESC
  s.homepage     = "https://github.com/forsen/WMSKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Erik Haider Forsén" => "erik@forsen.no" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/forsen/WMSKit.git", :tag => "#{s.version}" }
  s.source_files  = "WMSKit", "WMSKit/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
