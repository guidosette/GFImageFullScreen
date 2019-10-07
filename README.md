# GFImageFullScreen

[![CI Status](https://img.shields.io/travis/guidosette/GFImageFullScreen.svg?style=flat)](https://travis-ci.org/guidosette/GFImageFullScreen)
[![Version](https://img.shields.io/cocoapods/v/GFImageFullScreen.svg?style=flat)](https://cocoapods.org/pods/GFImageFullScreen)
[![License](https://img.shields.io/cocoapods/l/GFImageFullScreen.svg?style=flat)](https://cocoapods.org/pods/GFImageFullScreen)
[![Platform](https://img.shields.io/cocoapods/p/GFImageFullScreen.svg?style=flat)](https://cocoapods.org/pods/GFImageFullScreen)

## Example

![Alt Text](https://github.com/guidosette/GFImageFullScreen/blob/master/photo.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GFImageFullScreen is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GFImageFullScreen'
```

## How to use
	#import "GFImageFullScreen.h"

	[GFImageFullScreen showFromImageView:_image];
	
## Settings
	//	image
	[GFImageFullScreen setCornerRadius:-1];
	[GFImageFullScreen setBackgroundColor:[UIColor clearColor]];
	[GFImageFullScreen setMargin:20];
	//	border
	[GFImageFullScreen setBorderColor:[UIColor whiteColor]];
	[GFImageFullScreen setBorderWidth:4];

## Author

guidosette, guido.fanfani7@gmail.com

## License

GFImageFullScreen is available under the MIT license. See the LICENSE file for more info.
