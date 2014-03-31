//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//


@interface LAdHocLabel : UIView
{
    BOOL _shown;
}


+ (void)showAdHocNumber:(NSUInteger)adHocNumber buildNumber:(NSUInteger)buildNumber andDeveloperName:(NSString *)developerName;


@end