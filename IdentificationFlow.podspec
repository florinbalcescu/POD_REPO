Pod::Spec.new do |s|
  s.name         = "IdentificationFlow"
  s.version      = "0.0.1"
  s.summary      = "..."

  s.author       = "Me"
  s.platform     = :ios
  s.platform     = :ios, "10.0"
  s.license      = "Proprietary"
  s.homepage     = "http://127.0.0.1"

  s.source       = { :git => "file://path/to/repo"}

  s.source_files  = "./**/*.{h,m,swift}"

  s.dependency 'FireBase/Core', '5.7.0'
  s.dependency 'FireBase/MLVision'
  s.dependency 'FireBase/MLVisionFaceModel'

end