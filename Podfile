platform :ios, '14.0'

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

# 定义公共库
def CommonPods
  pod 'CocoaLumberjack/Swift'
  pod 'Toast', '4.1.1'
  pod 'Kingfisher', '7.9.1'
  pod 'MJRefresh', '3.7.5'
  pod 'EmptyDataSet-Swift', '5.0.0'
  pod 'FDFullscreenPopGesture', '1.1'
  pod 'Reachability', '3.2'
  pod 'SnapKit', '5.6.0'
  pod 'EmptyDataSet-Swift', '5.0.0'
  pod 'TZImagePickerController', '3.8.8'
  pod 'IQKeyboardManagerSwift', '8.0.0'
  pod 'Mach-Swift', '1.1.1'
  pod 'JXBanner', '0.3.6'
end

def OCFrameworks
  pod 'AFNetworking', '4.0.1'
  pod 'YYKit', '1.0.9'
end

def HostPods
  pod "GSCaptchaButton"
  pod 'BRPickerView/Default','2.9.1'
  pod 'LJContactManager', '1.0.7'
  pod 'FBSDKCoreKit', '17.4.0'
end

target 'VidaCash' do
  CommonPods()
  OCFrameworks()
  HostPods()
end

post_install do |installer|
  
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings['CODE_SIGN_IDENTITY'] = ''
  end
end
