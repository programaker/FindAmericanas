//
//  FindAmericanasAppDelegate.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindAmericanasViewController;

@interface FindAmericanasAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FindAmericanasViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FindAmericanasViewController *viewController;

@end

