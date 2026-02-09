# coding: utf-8
# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'EP QTc' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EP QTc
  pod 'DGCharts', :git => 'https://github.com/danielgindi/Charts', :branch => 'master'
  pod 'SigmaSwiftStatistics', :git => 'https://github.com/evgenyneu/SigmaSwiftStatistics', :branch => 'master'

  target 'EP QTcTests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
end
