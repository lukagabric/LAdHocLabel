//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


#import "AppDelegate.h"
#import "ViewController.h"
#import "LAdHocLabel.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [ViewController new];
    
    [LAdHocLabel showAdHocNumber:1 andDeveloperName:@"lgabric"];
    
    return YES;
}


@end