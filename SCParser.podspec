Pod::Spec.new do |s|
  s.name		= "SCParser"
  s.version		= "1.1"
  s.summary		= "Signed property list data parser"

  s.homepage		= "https://gitlab.com/danpashin/SCParser"
  s.license		= { :type => "MIT", :file => "LICENSE" }
  s.author		= { "Daniil Pashin" => "admin@danpashin.ru" }
  #s.source		= { :git => "git@gitlab.com:danpashin/SCParser.git", :tag => s.version.to_s }
  s.source		= { :git => "file:///Users/daniil/Desktop/Files/xcode_projects/SCParser", :tag => s.version.to_s }

  s.source_files	= "Classes/*"
  s.public_header_files = "Classes/Public/*.h"

  s.platform		= :ios, "8.0"
  s.requires_arc 	= true
  s.framework		= "Foundation"
end