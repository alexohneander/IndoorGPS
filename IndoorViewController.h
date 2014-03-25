//
//  IndoorViewController.h
//  IndoorGPS
//
//  Created by Alex on 2/3/14.
//  Copyright (c) 2014 Alex Wellnitz. All rights reserved.
//

#import <UIKit/UIKit.h>

/* I dont need this anymore
#import "GCDAsyncSocket.h"
*/
@interface IndoorViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* beaconDistanceOne;
@property (nonatomic, strong) IBOutlet UILabel* beaconLabelOne;

@end

