source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

abstract_target 'App' do
    pod 'PusherSwift'

    target 'Pusher'

    # Test targets
    target 'PusherTests' do
        inherit! :search_paths
    end
end
