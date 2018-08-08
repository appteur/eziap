Pod::Spec.new do |s|

  s.name         = "EzIAP"
  s.version      = "1.0.0"
  s.summary      = "A framework to speed development time related to handling in app purchases for iOS in Swift."
  s.description  = "This project is intended to reduce development time for Swift projects integrating with native in app purchase functionality."
  s.homepage     = "https://github.com/appteur/eziap.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = "Seth Arnott"
  s.platform     = :ios, "10.0"
  s.swift_version = '4.1'
  
  s.source 		 = { :git => 'https://github.com/appteur/eziap.git', :tag => "#{s.version}" }
  s.source_files = 'EzIAP/*.{h,m,swift}', 'EzIAP/**/*.{h,m,swift}'
  
end
  
