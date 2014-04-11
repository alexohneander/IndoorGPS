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


//Calculating
@property (nonatomic, strong)   NSMutableDictionary*        beaconDictionary;
@property(nonatomic)            NSMutableDictionary*        radiusDict;

//Moving Image (Map)
@property(nonatomic)            UIImage*                    ballImage;
@property(nonatomic)            UIImageView*                ball;
@property(nonatomic, assign)    CGPoint                     position;

@end


@implementation IndoorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Animation (Test Ball)
    UIImage *ballImage = [UIImage imageNamed:@"positionPoint.png"];
    self.ball = [[UIImageView alloc] initWithImage:ballImage];
    [self.view addSubview:self.ball];
    
    
    
    ///////////Beacon /////////////
    self.beaconDictionary     =   [NSMutableDictionary dictionary];
    
    
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
        
            NSString* majorMinor        =   [NSString stringWithFormat:
                                         @"%i-%i",
                                         [beacon.major unsignedShortValue],
                                         [beacon.minor unsignedShortValue]];
        
        
        
        //The working entry
        NSString* beaconDistance     =   [NSString stringWithFormat:@"%f",[beacon.distance floatValue]];
        
        
        
        //Checking if Key exist
        NSMutableArray* distanceArray = [NSMutableArray array];
        
        if ([self.beaconDictionary objectForKey:majorMinor])
        {
            distanceArray = [self.beaconDictionary objectForKey:majorMinor];
            
        }
        
        [distanceArray addObject:beaconDistance];
        
        //if more than 9 values in activeBeaconIDs than...
        if ([distanceArray count] > 9 ){
            [activeBeaconIds addObject:majorMinor];
        }
        
        [self.beaconDictionary  setObject:distanceArray forKey:majorMinor];
        
    }
    
    NSLog(@"Beacon Distanzen: %@", self.beaconDictionary);
    
    //Checking if more than 2 Beacons alife.
    if([activeBeaconIds count] > 2)
    {
        
        
        for (int i=0; i<[activeBeaconIds count] ; i++)
        {
    
            
            NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:[self.beaconDictionary objectForKey:activeBeaconIds[i]]];
            
            NSInteger maxCount = 0;
            NSNumber *maxNumber;
            
            for (NSNumber *number in countedSet) {
                if ([countedSet countForObject:number] > maxCount) {
                    maxCount = [countedSet countForObject:number];
                    maxNumber = number;
                    
                    if (!self.radiusDict) {
                        self.radiusDict = [NSMutableDictionary dictionary];
                    }
                    [self.radiusDict setObject:maxNumber forKey:activeBeaconIds[i]];
                    
                }
            }
        }
        
        
        NSLog(@"Mein DIC= %@", self.radiusDict[@"42634-3111"]);
        
        float BeaconDistanceOne   = [self.radiusDict[@"9576-49222"]   floatValue];
        float BeaconDistanceTwo   = [self.radiusDict[@"42634-3111"]   floatValue];
        float BeaconDistanceThree = [self.radiusDict[@"30219-54563"]  floatValue];
    
        
        //BeaconID = 9576-49222
        float beaconOneCoordinateX      = 0;
        float beaconOneCoordinateY      = 0;
        
        //BeaconID = 42634-3111
        float beaconTwoCoordinateX      = 320;
        float beaconTwoCoordinateY      = 0;
        
        // BeaconID = 30219-54563
        float beaconThreeCoordinateX    = 160;
        float beaconThreeCoordinateY    = 480;

        
        //Calculating Distances with Factor (cm to Pixel)   *1 = Factor cm to Pixel
        BeaconDistanceOne   = (BeaconDistanceOne * 100)     *1;
        BeaconDistanceTwo   = (BeaconDistanceTwo * 100)     *1;
        BeaconDistanceThree = (BeaconDistanceThree * 100)   *1;
        
        
        //Calculating Delta Alpha Beta
        float Delta   = 4 * ((beaconOneCoordinateX - beaconTwoCoordinateX) * (beaconOneCoordinateY - beaconThreeCoordinateY) - (beaconOneCoordinateX - beaconThreeCoordinateX) * (beaconOneCoordinateY - beaconTwoCoordinateY));
        float Alpha   = (BeaconDistanceTwo * BeaconDistanceTwo) - (BeaconDistanceOne * BeaconDistanceOne) - (beaconTwoCoordinateX * beaconTwoCoordinateX) + (beaconOneCoordinateX * beaconOneCoordinateX) - (beaconTwoCoordinateY * beaconTwoCoordinateY) + (beaconOneCoordinateY * beaconOneCoordinateY);
        float Beta    = (BeaconDistanceThree * BeaconDistanceThree) - (BeaconDistanceOne * BeaconDistanceOne) - (beaconThreeCoordinateX * beaconThreeCoordinateX) + (beaconOneCoordinateX * beaconOneCoordinateX) - (beaconThreeCoordinateY * beaconThreeCoordinateY) + (beaconOneCoordinateY * beaconOneCoordinateY);
        
        
        
        //Real Calculating the Position (Triletaration
        float PositionX = (1/Delta) * (2 * Alpha * (beaconOneCoordinateY - beaconThreeCoordinateY) - 2 * Beta * (beaconOneCoordinateY - beaconTwoCoordinateY));
        float PositionY = (1/Delta) * (2 * Beta * (beaconOneCoordinateX - beaconTwoCoordinateX) - 2 * Alpha * (beaconOneCoordinateX - beaconThreeCoordinateX));
        
        
        NSLog(@"PositionX = %f", PositionX);
        NSLog(@"PositionX = %f", PositionY);
        
        NSString* PositionStringX = [NSString stringWithFormat:
                                     @"%f",
                                     PositionX];
        NSString* PositionStringY = [NSString stringWithFormat:
                                     @"%f",
                                     PositionY];
        
    
        self.beaconDistanceOne.text     = PositionStringX;
        self.distanceLabel.text         = PositionStringY;
        
        
        self.position = CGPointMake(PositionX, PositionY);
        self.ball.center = self.position;
        
        
        /*
         Deleting Values from Dictionary
         */
        [self.beaconDictionary removeAllObjects];
        NSLog(@"Dictionary Release");
         
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
