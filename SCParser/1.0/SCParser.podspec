Pod::Spec.new do |s|
  s.name             = "SCParser"
  s.version          = "1.0"
  s.summary	     = "Signed CSSM "
  s.homepage	     = "https://gitlab.com/danpashin/SCParser"
  s.author           = { "Daniil Pashin" => "admin@danpashin.ru" }
  s.source           = { :git => "git@gitlab.com:danpashin/SCParser.git", :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = "SCParser/**/*.{h,m}"

  s.frameworks = 'Foundation', 'CoreFoundation'
  s.module_name = 'SCParser'
end