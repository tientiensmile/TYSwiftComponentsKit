#
#  Be sure to run `pod spec lint TYSwiftComponentsKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "TYSwiftComponentsKit"
  spec.version      = "0.0.1"
  spec.summary      = "A framework contains common UI components in Swift."
  spec.description  = "TYSwiftComponentsKit is a small and lightweight Swift framework including many common UI components"
  spec.homepage     = "https://github.com/tientiensmile/TYSwiftComponentsKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "AudreyWang" => "audreywang8216@gmail.com" }
  spec.source       = { :git => "https://github.com/tientiensmile/TYSwiftComponentsKit.git", :tag => spec.version }

  #目標限定在11.0以上
  spec.ios.deployment_target = '11.0'
  spec.swift_version = ['4.2', '5.0', '5.1', '5.2', '5.3']
  
  spec.subspec 'TYSegmentedControl' do |ui|
    # 指定在pod install下载的内容
    # **匹配的是目录，*.{h,m,swift}是匹配的所有文件，*是通配符
    ui.source_files = "TYSwiftComponentsKit/TYSwiftComponentsKit/Classes/TYSegmentedControl/**/*.{h,m,swift}", 'TYSwiftComponentsKit/TYSwiftComponentsKit/Classes/Utility/**/*.{h,m,swift}'

    ui.resource_bundles = {
      'TYSwiftComponentsKit' => ['TYSwiftComponentsKit/TYSwiftComponentsKit/Resources/*.*']
    }
  end

end
