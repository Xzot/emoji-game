platform :ios, '14.0'

target 'emoji-game' do
  use_frameworks!
  # Утилиты
  pod 'Realm'
  pod 'RealmSwift'
  pod 'SwiftGen'
  pod 'Swinject'
  pod 'TinyConstraints'
  pod 'SwiftyUserDefaults'
  pod 'RevealingSplashView'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
