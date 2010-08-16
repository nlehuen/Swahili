//
//  SwahiliAppDelegate.h
//  Swahili
//
//  Created by Nicolas LEHUEN on 15/08/10.
//  Copyright CRM Company Group 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface SwahiliAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

