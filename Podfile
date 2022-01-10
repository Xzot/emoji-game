platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'emoji-game' do
  use_frameworks!
  # Утилиты
  pod 'Realm'
  pod 'RealmSwift'
  pod 'SwiftGen'
  pod 'Swinject'
  pod 'TinyConstraints'
  pod 'SwiftyUserDefaults'
  pod 'TOMSMorphingLabel'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
