# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'TakeawayTest' do
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint'

  target 'TakeawayTestTests' do
    inherit! :search_paths
        pod 'RxTest'
  end

  target 'TakeawayTestUITests' do
  end

end
 # Enable TRACE_RESOURCES for RxSwift debugging
post_install do |installer|
   installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
         target.build_configurations.each do |config|
            if config.name == 'Debug'
               config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
         end
      end
   end
end
