# RxSwiftDitto

[![CI Status](https://img.shields.io/travis/2183729/RxSwiftDitto.svg?style=flat)](https://travis-ci.org/2183729/RxSwiftDitto)
[![Version](https://img.shields.io/cocoapods/v/RxSwiftDitto.svg?style=flat)](https://cocoapods.org/pods/RxSwiftDitto)
[![License](https://img.shields.io/cocoapods/l/RxSwiftDitto.svg?style=flat)](https://cocoapods.org/pods/RxSwiftDitto)
[![Platform](https://img.shields.io/cocoapods/p/RxSwiftDitto.svg?style=flat)](https://cocoapods.org/pods/RxSwiftDitto)

This is a Cocoapod that adds extension methods for RxSwift on the `.rx` namespace for `DittoCollection`, `DittoPendingCursorOperation` and `DittoPendingIDSpecificOperation`

## Installation

RxSwiftDitto is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxSwiftDitto'
```

### For testing...

DittoSwift requires a license token in order to work properly. Please contact the Ditto team on at [contact@ditto.live](mailto:contact@ditto.live) to get access to a license token. This project loads a license token from a file `license_token.txt`. Once you've obtained a license token, you can create the file and paste it in. Once you open up `RxSwiftDitto.xcworkspace` you will see that the `license_token.txt` is part of the test target. Note: `license_token.txt` is part of the `.gitignore`. Ensure not to accidentally commit and push it up to this repo. 

## Usage:

Simple live queries with snapshots of `[DittoDocument]`

```swift
var disposeBag = DisposeBag()

ditto
  .store["cars"]
  .find("color == 'red'")
  .rx
  .liveQuery
  .subscribe(onNext: { docs in
    // docs is `[DittoDocument]`
  })
  .disposed(by: disposeBag)
```

Simple live queries with snapshots of `[DittoDocument]`

```swift
var disposeBag = DisposeBag()

ditto
  .store["cars"]
  .find("color == 'red'")
  .rx
  .liveQueryDocumentsWithEvent
  .subscribe(onNext: { (docs, event) in
    // docs is `[DittoDocument]`
    // event is [DittoLiveQueryEvent]
  })
  .disposed(by: disposeBag)
```
## Author

2183729, max@ditto.live

## License

RxSwiftDitto is available under the MIT license. See the LICENSE file for more info.
