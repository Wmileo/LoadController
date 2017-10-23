
Pod::Spec.new do |s|

  s.name         = "LoadController"
  s.version      = "2.0.5"
  s.summary      = "用于UIScrollView的上拉下拉加载数据"

  s.description  = <<-DESC
                   用于UIScrollView的上拉下拉加载数据.
                   DESC

  s.homepage     = "https://github.com/Wmileo/LoadController"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "ileo" => "work.mileo@gmail.com" }
  # Or just: s.author    = "ileo"
  # s.authors            = { "ileo" => "work.mileo@gmail.com" }
  # s.social_media_url   = "http://twitter.com/ileo"

  # s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Wmileo/LoadController.git", :tag => s.version.to_s }


  s.source_files  = "RefreshView/RefreshView/*.{h,m}"

  s.requires_arc = true

end
