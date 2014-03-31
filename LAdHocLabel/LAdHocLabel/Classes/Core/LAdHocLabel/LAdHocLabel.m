//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


#import "LAdHocLabel.h"
#import <QuartzCore/QuartzCore.h>


@implementation LAdHocLabel


#define VIEW_HEIGHT 50


#pragma mark - init & dealloc


- (id)initWithMessage:(NSString *)adhocMessage
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, [self getStatusBarHeight], [self getStatusBarWidth], VIEW_HEIGHT);
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.frame.size.width, self.frame.size.height + 50)];
        cornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cornerView.layer.cornerRadius = 20;
        cornerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        cornerView.userInteractionEnabled = NO;
        [self addSubview:cornerView];
        
        UILabel *adhocLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:adhocLabel];
        
        adhocLabel.userInteractionEnabled = NO;
        adhocLabel.textAlignment = NSTextAlignmentCenter;
        adhocLabel.lineBreakMode = NSLineBreakByWordWrapping;
        adhocLabel.numberOfLines = 2;
        adhocLabel.backgroundColor = [UIColor clearColor];
        
        adhocLabel.font = [UIFont boldSystemFontOfSize:12];
        adhocLabel.textColor = [UIColor whiteColor];
        adhocLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        adhocLabel.text = adhocMessage;
        
        UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
        [appWindow addSubview:self];
        
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Orientation change calculations


- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}


- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat angle = [self angleForOrientation:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    
    if (!CGAffineTransformEqualToTransform(self.transform, transform))
    {
        self.transform = transform;
    }
    
    CGRect frame = [self frameForOrientation:orientation];
    
    if (!CGRectEqualToRect(self.frame, frame))
    {
        self.frame = frame;
    }
}


- (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
    
    return UIInterfaceOrientationIsLandscape(orientation) ? size.width : size.height;
}


- (CGFloat)getStatusBarWidth
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
    
    return UIInterfaceOrientationIsLandscape(orientation) ? size.height : size.width;
}


- (CGFloat)angleForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}


- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect windowBounds = [[UIApplication sharedApplication] keyWindow].bounds;
    
    CGRect frame;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            frame = CGRectMake(0, _shown ? windowBounds.size.height - VIEW_HEIGHT - [self getStatusBarHeight] : windowBounds.size.height - [self getStatusBarHeight], [self getStatusBarWidth], VIEW_HEIGHT);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            frame = CGRectMake(_shown ? [self getStatusBarHeight] : -VIEW_HEIGHT, 0, VIEW_HEIGHT, [self getStatusBarWidth]);
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame = CGRectMake(_shown ? windowBounds.size.width - VIEW_HEIGHT - [self getStatusBarHeight] : windowBounds.size.width - [self getStatusBarHeight], 0, VIEW_HEIGHT, [self getStatusBarWidth]);
            break;
        default:
            frame = CGRectMake(0, _shown ? [self getStatusBarHeight] : -VIEW_HEIGHT, [self getStatusBarWidth], VIEW_HEIGHT);
            break;
    }
    
    return frame;
}


#pragma mark - Show/hide animations


- (void)show
{
    if (_shown) return;
    
    _shown = YES;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = [self frameForOrientation:orientation];
    }];
}


- (void)hide
{
    if (!_shown) return;
    
    _shown = NO;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = [self frameForOrientation:orientation];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Number formatter


+ (NSString *)formattedWithInt:(NSUInteger)integer
{
	NSNumber *num = [NSNumber numberWithInt:integer];
    
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
	[numberFormatter setMaximumFractionDigits:0];
	[numberFormatter setMinimumIntegerDigits:2];
    
	return [numberFormatter stringFromNumber:num];
}


#pragma mark - Static methods to show label


+ (void)showAdHocNumber:(NSUInteger)adHocNumber buildNumber:(NSUInteger)buildNumber andDeveloperName:(NSString *)developerName
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDict objectForKey:@"CFBundleVersion"];
        NSString *appName = [infoDict objectForKey:@"CFBundleName"];
        
        NSString *adhocMessage;
        
        if ([version hasPrefix:@"VER"])
        {
            adhocMessage = [NSString stringWithFormat:@"%@, %@\n%@", appName, developerName, version];
        }
        else
        {
            adhocMessage = [NSString stringWithFormat:@"%@ v.%@ AH%@ B%@\n%s %s, %@", appName, version, [self formattedWithInt:adHocNumber], [self formattedWithInt:buildNumber], __DATE__, __TIME__, developerName];
        }
        
        LAdHocLabel *adhocLabel = [[LAdHocLabel alloc] initWithMessage:adhocMessage];
        
        [adhocLabel show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
            [adhocLabel hide];
        });
    });
}


#pragma mark -


@end