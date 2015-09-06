//
//  ViewController.h
//  AKImageViewerDemo
//
//  Created by Alec Kretch on 9/5/15.
//  Copyright (c) 2015 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKImageViewerViewController.h"

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet AKImageViewerViewController *aKImageViewerViewController;
@property (retain, nonatomic) IBOutlet UIButton *btnLionPicture;
@property (retain, nonatomic) IBOutlet UIButton *btnSceneryPicture;

@end
