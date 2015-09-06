//
//  AKImageViewerViewController.m
//  AKImageViewerViewController
//
//  Created by Alec Kretch on 8/28/15.
//  Copyright (c) 2015 Alec Kretch. All rights reserved.
//

#import "AKImageViewerViewController.h"

@interface AKImageViewerViewController ()

@end

@implementation AKImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    //setup scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //register taps
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    //set them to the view
    [self.scrollView addGestureRecognizer:tapOnce];
    [self.scrollView addGestureRecognizer:tapTwice];
    
    [self setCancelButton];
    
}

- (void)setCancelButton {
    //add forward arrow
    UIImage *imgCancel = [UIImage imageNamed:@"btn_cancel.png"];
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnCancel addTarget:self action:@selector(onTapButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel setImage:imgCancel forState:UIControlStateNormal];
    [self.btnCancel setTintColor:[UIColor whiteColor]];
    self.btnCancel.frame = CGRectMake(self.view.frame.size.width-(imgCancel.size.width*2)-18, 18, imgCancel.size.width*2, imgCancel.size.height*2);
    [self.view addSubview:self.btnCancel];
    
}

- (void)onTapButtonCancel {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}

- (void)centerPictureFromPoint:(CGPoint)point ofSize:(CGSize)size withCornerRadius:(float)radius {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, size.width, size.height)];
    self.imageView.layer.cornerRadius = radius;
    self.imageView.clipsToBounds = YES;
    
    self.imageView.image = self.image;
    [self.scrollView addSubview:self.imageView];
    
    [UIView animateWithDuration:0.3f animations:^{
        int imageWidth = self.image.size.width;
        int imageHeight = self.image.size.height;
        int imageRatio = imageWidth/imageHeight;
        int viewRatio = self.view.frame.size.width/self.view.frame.size.height;
        int ratio;
        if (imageRatio >= viewRatio) //image is wider
        {
            ratio = imageWidth/self.view.frame.size.width;
        }
        else
        {
            ratio = imageHeight/self.view.frame.size.height;
        }
        int newWidth = imageWidth/ratio;
        int newHeight = imageHeight/ratio;
        self.imageView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, newWidth, newHeight);
        self.imageView.center = self.scrollView.center;
        self.imageView.layer.cornerRadius = 0.0;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        if (!self.disableSavingImage)
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [self.scrollView addGestureRecognizer:longPress];
        }
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
        [self.scrollView addGestureRecognizer:self.pan];
    }];
    
}

- (void)tapOnce:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.btnCancel isHidden])
    {
        [UIView animateWithDuration:0.1f animations:^{
            self.btnCancel.alpha = 1.0;
            self.btnCancel.hidden = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1f animations:^{
            self.btnCancel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.btnCancel.hidden = YES;
        }];
    }
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) //if zoomed out
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    
}

- (void)tapTwice:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) //if zoomed all the way out
    {
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES]; //zoom in at the tapped point
    }
    else
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES]; //or else zoom out on double tap
    }
    
}

- (void)moveImage:(UIPanGestureRecognizer *)gesture
{
    //hide cancel button
    if (![self.btnCancel isHidden])
    {
        [UIView animateWithDuration:0.1f animations:^{
            self.btnCancel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.btnCancel.hidden = YES;
        }];
    }
    
    int deltaY = [gesture translationInView:self.scrollView].y;
    CGPoint translatedPoint = CGPointMake(self.view.center.x, self.view.center.y+deltaY);
    self.scrollView.center = translatedPoint;
    
    if ((gesture.state == UIGestureRecognizerStateEnded))
    {
        CGFloat velocityY = ([gesture velocityInView:self.scrollView].y);
        int maxDeltaY = (self.view.frame.size.height-self.imageView.frame.size.height)/2;
        if (velocityY > 700 || (abs(deltaY)>maxDeltaY && deltaY>0)) //swipe down
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView animateWithDuration:0.3f animations:^{
                self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.view.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height);
                self.view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }
        else if (velocityY < -700 || (abs(deltaY)>maxDeltaY && deltaY<0)) //swipe up
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView animateWithDuration:0.3f animations:^{
                self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, -self.imageView.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height);
                self.view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }
        else //return to center
        {
            [UIView animateWithDuration:0.1f animations:^{
                self.btnCancel.alpha = 1.0;
                self.btnCancel.hidden = NO;
                self.scrollView.center = self.view.center;
            }];
        }
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to camera roll", nil];
        [actionSheet showInView:self.view];
    }
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //save to camera roll
    {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    
}

- (void) image:(UIImage *)image finishedSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Uh, oh!" message: @"There was a problem saving the photo." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success!" message: @"The picture has been saved to your camera roll." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale)
    {
        if ([self.btnCancel isHidden])
        {
            [UIView animateWithDuration:0.1f animations:^{
                self.btnCancel.alpha = 1.0;
                self.btnCancel.hidden = NO;
            }];
        }
        [self.scrollView addGestureRecognizer:self.pan];
    }
    else
    {
        if (![self.btnCancel isHidden])
        {
            [UIView animateWithDuration:0.1f animations:^{
                self.btnCancel.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.btnCancel.hidden = YES;
            }];
        }
        [self.scrollView removeGestureRecognizer:self.pan];
    }
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    
    CGRect zoomRect;
    
    zoomRect.size.height = self.imageView.frame.size.height / scale;
    zoomRect.size.width  = self.imageView.frame.size.width  / scale;
    
    center = [self.imageView convertPoint:center fromView:self.view];
    
    zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
