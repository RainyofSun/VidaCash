platform :ios, '14.0'

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

# 定义公共库
def CommonPods
  pod 'CocoaLumberjack/Swift'
  pod 'Toast', '4.1.1'
  pod 'Kingfisher', '~> 8.2.0'
  pod 'MJRefresh', '3.7.5'
  pod 'EmptyDataSet-Swift', '5.0.0'
  pod 'FDFullscreenPopGesture', '1.1'
  pod 'Reachability', '3.7.6'
  pod 'SnapKit', '5.7.1'
  pod 'EmptyDataSet-Swift', '5.0.0'
  pod 'TZImagePickerController', '3.8.8'
  pod 'IQKeyboardManagerSwift', '8.0.0'
  pod 'Mach-Swift', '1.1.1'
  pod 'JXBanner', '0.3.6'
  pod 'JKSwiftExtension', "2.7.1"
  pod 'DGCharts', '5.1.0'
end

def OCFrameworks
  pod 'AFNetworking', :git => 'https://github.com/crasowas/AFNetworking.git'
  pod 'YYKit', '1.0.9'
end

def HostPods
  pod "GSCaptchaButton"
  pod 'BRPickerView/Default','2.9.1'
  pod 'LJContactManager', '1.0.7'
  pod 'FBSDKCoreKit', '18.0.0'
end

target 'VidaCash' do
  CommonPods()
  OCFrameworks()
  HostPods()
end
