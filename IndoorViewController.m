//
//  IndoorViewController.m
//  IndoorGPS
//
//  Created by Alex on 2/3/14.
//  Copyright (c) 2014 Alex Wellnitz. All rights reserved.
//

#import "IndoorViewController.h"
#import "ESTBeaconManager.h"

//Animation (Test Ball)//
#import <QuartzCore/QuartzCore.h>
//Animation (Test Ball)//

@interface IndoorViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager*         beaconManager;

/* I dont need this anymore
 @property (nonatomic, strong) GCDAsyncSocket            *gcdAsync;
 */

@property (nonatomic, strong)   NSMutableData*              buffer;
@property (nonatomic, strong)   NSURLConnection*            connection;
@property (nonatomic, copy)     NSString*                   parsedUrl;
@property (nonatomic)           NSInteger                   averageArrayIndex;
@property (nonatomic, strong)   NSMutableDictionary*        beaconDictionary;

@property(nonatomic)            UIImage*                    ballImage;
@property(nonatomic)            UIImageView*                ball;
@property(nonatomic, assign)    CGPoint                     position;
@property(nonatomic)            NSString*                   beaconDistance;
@property(nonatomic)            NSInteger*                  countDistance;
@property(nonatomic)            NSInteger                   beaconInteger;
@property(nonatomic)            NSMutableArray*             distanceArray;
@property (nonatomic, assign)   int                         index;
@end


@implementation IndoorViewController

/* I don`t need this anymore!
 - (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
 {
 NSLog(@"Cool, I'm connected! That was easy.");
 }
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Animation (Test Ball)//
    UIImage *ballImage = [UIImage imageNamed:@"test-ball"];
    self.ball = [[UIImageView alloc] initWithImage:ballImage];
    [self.view addSubview:self.ball];
    
    //Animation (Test Ball)//
    
    
    ///////////Beacon /////////////
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
    
    
    
    
    CGPoint position  = CGPointMake(1,1);
    [self ballAnimation:position];
    
    
}

- (void)ballAnimation:(CGPoint)position{
    position.x = 0;
    position.y = 1000;
    self.ball.center = position;
}


-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    NSMutableArray* activeBeaconIds = [NSMutableArray array];
    for (ESTBeacon* beacon in beacons)
    {
        //Format Label Text, ID and Distance
        NSString* labelText         =   [NSString stringWithFormat:
                                         @"Major: %i, Minor: %i\nRegion: ",
                                         [beacon.major unsignedShortValue],
                                         [beacon.minor unsignedShortValue]];
        
        NSString* majorMinor        =   [NSString stringWithFormat:
                                         @"%i-%i",
                                         [beacon.major unsignedShortValue],
                                         [beacon.minor unsignedShortValue]];
        
        
        
        //The working entry
        self.beaconDistance     =   [NSString stringWithFormat:@"%d",[beacon.distance intValue]];
        
        
        //Label Text
        self.beaconDistanceOne.text = self.beaconDistance;
        self.distanceLabel.text = labelText;
        
        
        //Checking if Key exist
        self.distanceArray = [NSMutableArray array];
        
        if ([self.beaconDictionary objectForKey:majorMinor])
        {
            self.distanceArray = [self.beaconDictionary objectForKey:majorMinor];
            
        }
        
        [self.distanceArray addObject:self.beaconDistance];
        
        if ([self.distanceArray count] > 9 ){
            [activeBeaconIds addObject:majorMinor];
        }
        
        [self.beaconDictionary  setObject:self.distanceArray forKey:majorMinor];
        
    }
    
    
    
    self.index = 0;
    
    //Checking if more than 2 Beacons alife.
    if([activeBeaconIds count] > 2)
    {
        self.position = CGPointMake(150+20, 180+30);
        self.ball.center = self.position;
        
        
        for (int i=0; i<[activeBeaconIds count] ; i++)
        {
            NSLog(@"%@", [self.beaconDictionary objectForKey:activeBeaconIds[i]]);
            
            
            
            
            NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:[self.beaconDictionary objectForKey:activeBeaconIds[i]]];
            
            NSInteger maxCount = 0;
            NSNumber *maxNumber;
            
            for (NSNumber *number in countedSet) {
                if ([countedSet countForObject:number] > maxCount) {
                    maxCount = [countedSet countForObject:number];
                    maxNumber = number;
                    NSLog(@" Mein Asymetrischer Mittelwert= %@", maxNumber);
                }
            }
            
            
            
            
        
        }
        
        
        
        
        
        /*
         Diese funktion wird aufgerufen wenn das Dictionary geleert werden soll!
         */
        [self.beaconDictionary removeAllObjects];
        NSLog(@"My Dic = %@ ", self.beaconDictionary);
        NSLog(@"Dictionary wurde geleert");
         
    }
    
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
