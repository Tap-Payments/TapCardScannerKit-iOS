# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'TapCardScanner-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TapCardScanner-iOS
  pod 'CommonDataModelsKit-iOS'
  pod 'TapCardVlidatorKit-iOS'
end

target 'TapCardScannerExample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SheetyColors'
  pod 'CommonDataModelsKit-iOS'
  # Pods for TapCardScannerExample


post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end


end
