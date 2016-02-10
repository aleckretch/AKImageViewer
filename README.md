# AKImageViewer
A clean iOS add-on to view images full-sized with a smooth interface and feel.

## Adding AKImageViewer to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add AKImageViewer to your project.

1. Add a pod entry for AKImageViewer to your Podfile `pod 'AKImageViewer'`
2. Install the pod(s) by running `pod install`.
3. Include AKImageViewer wherever you need it with `#import "AKImageViewerViewController.h"`.

### Source files

Alternatively you can directly add the `AKImageViewerViewController.h` and `AKImageViewerViewController.m` source files to your project.

1. Download the [latest code version](https://github.com/aleckretch/AKImageViewer/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `AKImageViewerViewController.h` and `AKImageViewerViewController.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include AKImageViewer wherever you need it with `#import "AKImageViewerViewController.h"`.

## Usage

Add AKImageViewerViewController.view as a subview of the current view. You must set an image (`image`) and cancel icon (`imgCancel`).

```objective-c
AKImageViewerController *aKImageViewerViewController = [[AKImageViewerViewController alloc] init];
aKImageViewerViewController.image = [UIImage imageName:@"lion.png"];
aKImageViewerViewController.imgCancel = [UIImage imageNamed:@"btn_cancel.png"];
[self.view addSubview:aKImageViewerViewController.view];
[aKImageViewerViewController centerPictureFromPoint:CGPointMake(0,0) ofSize:CGSizeMake(30,30) withCornerRadius:1.0];
```

The ability to save the image is included automatically. To disable this feature, set the `disableSavingImage` boolean to YES.

```objective-c
aKImageViewerViewController.disableSavingImage = YES;
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
