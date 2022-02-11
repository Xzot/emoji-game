platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'EmojiGame' do
  use_frameworks!
  # Утилиты
  pod 'Gifu'
  pod 'Realm'
  pod 'Firebase'
  pod 'RealmSwift'
  pod 'SwiftGen'
  pod 'Swinject'
  pod 'SwiftyStoreKit'
  pod 'TinyConstraints'
  pod 'SwiftyUserDefaults'
  pod 'Google-Mobile-Ads-SDK'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
