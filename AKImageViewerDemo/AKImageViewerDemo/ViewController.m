//
//  ViewController.m
//  AKImageViewerDemo
//
//  Created by Alec Kretch on 9/5/15.
//  Copyright (c) 2015 Alec Kretch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnLionPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLionPicture setFrame:CGRectMake(100, 100, 40, 40)];
    [self.btnLionPicture addTarget:self action:@selector(onTapLionButton) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLionPicture setImage:[UIImage imageNamed:@"lion.jpg"] forState:UIControlStateNormal];
    self.btnLionPicture.layer.cornerRadius = 20.0;
    self.btnLionPicture.clipsToBounds = YES;
    self.btnLionPicture.exclusiveTouch = YES;
    [self.view addSubview:self.btnLionPicture];
    
    self.btnSceneryPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSceneryPicture setFrame:CGRectMake(self.view.frame.size.width-220, 300, 200, 126)];
    [self.btnSceneryPicture addTarget:self action:@selector(onTapSceneryButton) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSceneryPicture setImage:[UIImage imageNamed:@"scenery.jpg"] forState:UIControlStateNormal];
    self.btnSceneryPicture.layer.cornerRadius = 4.0;
    self.btnSceneryPicture.clipsToBounds = YES;
    self.btnSceneryPicture.exclusiveTouch = YES;
    [self.view addSubview:self.btnSceneryPicture];
    
}

- (void)onTapLionButton {
    self.aKImageViewerViewController = [[AKImageViewerViewController alloc] init];
    self.aKImageViewerViewController.image = self.btnLionPicture.imageView.image;
    self.aKImageViewerViewController.imgCancel = [UIImage imageNamed:@"btn_cancel.png"];

    [self.view addSubview:self.aKImageViewerViewController.view];
    [self.aKImageViewerViewController centerPictureFromPoint:self.btnLionPicture.frame.origin ofSize:self.btnLionPicture.frame.size withCornerRadius:self.btnLionPicture.layer.cornerRadius];
    
}

- (void)onTapSceneryButton {
    self.aKImageViewerViewController = [[AKImageViewerViewController alloc] init];
    self.aKImageViewerViewController.image = self.btnSceneryPicture.imageView.image;
    self.aKImageViewerViewController.imgCancel = [UIImage imageNamed:@"btn_cancel.png"];
    self.aKImageViewerViewController.disableSavingImage = YES;
    [self.view addSubview:self.aKImageViewerViewController.view];
    [self.aKImageViewerViewController centerPictureFromPoint:self.btnSceneryPicture.frame.origin ofSize:self.btnSceneryPicture.frame.size withCornerRadius:self.btnSceneryPicture.layer.cornerRadius];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
