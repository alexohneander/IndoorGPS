//
//  AppDelegate.h
//  IndoorGPS
//
//  Created by Alex on 2/3/14.
//  Copyright (c) 2014 Alex Wellnitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndoorViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableArray *listArray;
@end
