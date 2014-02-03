//
//  IndoorViewController.h
//  IndoorGPS
//
//  Created by Alex on 2/3/14.
//  Copyright (c) 2014 Alex Wellnitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface IndoorViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* beaconDistanceOne;
@property (nonatomic, strong) IBOutlet UILabel* beaconLabelOne;

@property (nonatomic, strong) IBOutlet UILabel* distanceLabelTwo;
@property (nonatomic, strong) IBOutlet UILabel* beaconDistanceTwo;
@property (nonatomic, strong) IBOutlet UILabel* beaconLabelTwo;

@property (nonatomic, strong) IBOutlet UILabel* distanceLabelThree;
@property (nonatomic, strong) IBOutlet UILabel* beaconDistanceThree;
@property (nonatomic, strong) IBOutlet UILabel* beaconLabelThree;

@end

