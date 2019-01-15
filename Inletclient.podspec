#
# Be sure to run `pod lib lint Inletclient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Inletclient'
  s.version          = '1.0.11'
  s.summary          = 'The Swift client for the Inlet REST APIs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
# The Swift client for the Inlet REST APIs, implemented with RxSwift and Alamofire.
- Demo Data Enum
- Persona Map
- Payees include logo as base64
- Payees
- Current Bills
- Removed unnecesary table view controllers
- The client can be used offline now, easy testing.
                       DESC

  s.homepage         = 'https://github.com/localparty/Inletclient'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'localparty' => 'localparty@gmail.com' }
  s.source           = { :git => 'https://github.com/localparty/Inletclient.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Inletclient/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Inletclient' => ['Inletclient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'

end
