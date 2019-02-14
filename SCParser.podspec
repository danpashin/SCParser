Pod::Spec.new do |s|
  s.name		= "SCParser"
  s.version		= "1.1"
  s.summary		= "Signed property list data parser"

  s.homepage		= "https://github.com/danpashin/SCParser"
  s.license		= { :type => "MIT", :file => "LICENSE" }
  s.author		= { "Daniil Pashin" => "admin@danpashin.ru" }
  s.source		= { :git => "git@github.com:danpashin/SCParser.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*'

  s.public_header_files = 'Classes/Public/*.h'
  s.frameworks = 'Foundation'
end