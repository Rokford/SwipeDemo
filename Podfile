# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

target 'SwipeDemoSwift' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks

  	pod 'AffdexSDK-iOS'
	pod 'Koloda', '~> 4.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if (target.name == "AWSCore") || (target.name == 'AWSKinesis')
            target.build_configurations.each do |config|
                config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
            end
        end
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end