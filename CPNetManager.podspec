Pod::Spec.new do |s|

  s.name         = "CPNetManager"
  s.version      = "1.1.0"
  s.summary      = "网络请求框架"
  s.homepage     = "https://github.com/cp271007323/CPNetManager"
  s.license      = "MIT"
  s.author       = { "cp271007323" => "271007323@qq.com" }
  s.ios.deployment_target = "9.0"
  s.dependency 'AFNetworking'
  s.frameworks = "Foundation", "UIKit"
  s.source = { :git => "https://github.com/cp271007323/CPNetManager.git", :tag => s.version }
  s.source_files  = "CPNetManager" , "CPNetManager/*.{h,m}","CPNetManager/CPNetRequest" , "CPNetManager/CPNetRequest/*.{h,m}"

end
