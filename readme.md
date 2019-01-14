# Inletclient

[![CI Status](https://img.shields.io/travis/localparty/Inletclient.svg?style=flat)](https://travis-ci.org/localparty/Inletclient)
[![Version](https://img.shields.io/cocoapods/v/Inletclient.svg?style=flat)](https://cocoapods.org/pods/Inletclient)
[![License](https://img.shields.io/cocoapods/l/Inletclient.svg?style=flat)](https://cocoapods.org/pods/Inletclient)
[![Platform](https://img.shields.io/cocoapods/p/Inletclient.svg?style=flat)](https://cocoapods.org/pods/Inletclient)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Inletclient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Inletclient'
```

## Author

G Costilla, localparty@gmail.com

## License

Inletclient is available under the MIT license. See the LICENSE file for more info.

## Known Issues

### Missing Offline Control
There is not a control for switching online/offline.

### Double TableViewController
There might be no need of having another definition of a TableViewController v using the mirroring one.

### Lowercase
The repository names are not lower case, the preferred case.

### API Usage
It is ambiguos wheter other API calls are needed for geting the data of the customer. Whti the current API sequence we seem to be retrieving all the info that is required.

#### Automating the Json responses build
Other brands have not been tested, prob. I should have the API writing the files that are retrieved from Inlet to simplify offline testing.

#### Test Data
We should probably dump all the data into a swift struct and build a UI for testing it.

#### File Collision
The generated files fron JSON cafe didn't have a Class prefix so they collide with themselves, probably I should re-generate the classes using a Prefix

### Tests
