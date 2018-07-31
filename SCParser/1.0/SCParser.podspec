Pod::Spec.new do |spec|
  spec.name		= "SCParser"
  spec.version		= "1.0"
  spec.summary		= "Signed property list data parser"
  spec.homepage		= "https://gitlab.com/danpashin/SCParser"
  spec.license		= { :type => "BSD"}
  spec.author		= { "Daniil Pashin" => "admin@danpashin.ru" }
  spec.source		= { :git => "git@gitlab.com:danpashin/SCParser.git", :tag => spec.version.to_s }
  spec.source_files	= "SCParser/*"
  spec.platform		= :ios, "8.0"
  spec.requires_arc 	= true
  spec.framework 	= "Foundation"
end