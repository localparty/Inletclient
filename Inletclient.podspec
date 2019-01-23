#
# Be sure to run `pod lib lint Inletclient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Inletclient'
  s.version          = '1.0.15'
  s.summary          = 'The Swift client for the Inlet REST APIs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
# The Swift client for the Inlet REST APIs, implemented with RxSwift and Alamofire.
- 2019-01-23: fixed- the http response dumps woudl be overwritten, including now a UUID in the directory path
- 2019-01-23: fixed– the inline version would fail with a nil
- 2019-01-23: fixed- get brand profile would send the data in the request body v query items
- added a parameter for included the base64 svg logo of the brands
- excluded the extraneous data from the data enum
- updated the cid of the data for the setup executed on 2019-01-18
- Included updates to the data of the following:
-- WFTEST111918A
-- WFTEST011019B
-- WFTEST011019C
-- WFTEST011019D
- Demo Data Enum
- Persona Map
- Payees include logo as base64
- Payees
- Current Bills
- Removed unnecesary table view controllers
- The client can be used offline now, easy testing
- The data has been fixed to include brand ids
- The client has been fixed to include delivery points of type name and brand id
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
