//
//  IndoorViewController.m
//  IndoorGPS
//
//  Created by Alex on 2/3/14.
//  Copyright (c) 2014 Alex Wellnitz. All rights reserved.
//

#import "IndoorViewController.h"
#import "ESTBeaconManager.h"

@interface IndoorViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager*         beaconManager;
@property (nonatomic, strong) GCDAsyncSocket            *gcdAsync;

@property (nonatomic, strong)   NSMutableData               *buffer;
@property (nonatomic, strong)   NSURLConnection             *connection;
@property (nonatomic, copy)     NSString                    *parsedUrl;
@property (nonatomic)           NSInteger                   averageArrayIndex;
@property (nonatomic, strong)   NSMutableDictionary         *beaconDictionary;


@end

@implementation IndoorViewController


- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.beaconDictionary     =   [NSMutableDictionary dictionary];
    
    
    self.averageArrayIndex = 0;
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // craete manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initRegionWithIdentifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}




-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    for (ESTBeacon* beacon in beacons)
    {
        //Format Label Text, ID and Distance
        NSString* labelText         = [NSString stringWithFormat:
                                       @"Major: %i, Minor: %i\nRegion: ",
                                       [beacon.major unsignedShortValue],
                                       [beacon.minor unsignedShortValue]];
        
        NSString* majorMinor        = [NSString stringWithFormat:
                                       @"%i-%i",
                                       [beacon.major unsignedShortValue],
                                       [beacon.minor unsignedShortValue]];
       
        NSString* beaconDistance    = [NSString stringWithFormat:
                                       @"Distance: %i",
                                       [beacon.distance intValue]];
        
        //Label Text
        self.beaconDistanceOne.text = beaconDistance;
        self.distanceLabel.text = labelText;
        
        
        //Checking if Key exist
        NSMutableArray* distanceArray = [NSMutableArray array];
        
        if ([self.beaconDictionary objectForKey:majorMinor])
        {
            distanceArray = [self.beaconDictionary objectForKey:majorMinor];
            
        }
        
        [distanceArray addObject:beaconDistance];
        [self.beaconDictionary  setObject:distanceArray forKey:majorMinor];
        
    }
    NSLog(@"My Dic = %@ ", self.beaconDictionary);
    
    //Checking if more than 2 Beacons alife.
    if([beacons count] > 2)
    {
        
    }
    
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
