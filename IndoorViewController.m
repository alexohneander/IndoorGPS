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

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeacon* selectedBeacon;
@property (nonatomic, strong) ESTBeacon* selectedBeaconTwo;
@property (nonatomic, strong) ESTBeacon* selectedBeaconThree;
@property (nonatomic, strong) NSMutableData   *buffer;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) GCDAsyncSocket  *gcdAsync;
@property (nonatomic, copy)   NSDictionary    *keyDictionary;
@property (nonatomic, copy)   NSString        *parsedUrl;
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
    
    
    [self readPlist];
    
    
    
    
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
    //IF for Beacon One
    if([beacons count] > 0)
    {
        // initialy pick closest beacon
        self.selectedBeacon = [beacons objectAtIndex:0];
        
        NSString *selectedBeaconOne = [NSString stringWithFormat:
                                       @"B.One: %@",
                                       [beacons objectAtIndex:0]];
        
        NSLog(@"B.One: %@", selectedBeaconOne);
        self.beaconLabelOne.text = selectedBeaconOne;
    }
    
    
    //IF for Beacon Two
    if([beacons count] > 1)
    {
        // initialy pick closest beacon
        self.selectedBeaconTwo = [beacons objectAtIndex:1];
        
        NSString *selectedBeaconOne = [NSString stringWithFormat:
                                       @"B.Two: %@",
                                       [beacons objectAtIndex:1]];
        
        NSLog(@"B.Two: %@", selectedBeaconOne);
        self.beaconLabelTwo.text = selectedBeaconOne;
    }
    
    
    //IF for Beacon Three
    if([beacons count] > 2)
    {
        // initialy pick closest beacon
        self.selectedBeaconThree = [beacons objectAtIndex:2];
        
        NSString *selectedBeaconThree = [NSString stringWithFormat:
                                       @"B.Two: %@",
                                       [beacons objectAtIndex:2]];
        
        NSLog(@"B.Two: %@", selectedBeaconThree);
        self.beaconLabelThree.text = selectedBeaconThree;
    }
    
///////////////////////////////Beacon One/////////////////////////////////////
    // Beacon Postion!
    // beacon array is sorted based on distanceˆ
    // closest beacon is the first one
    NSString* labelText = [NSString stringWithFormat:
                           @"Major: %i, Minor: %i\nRegion: ",
                           [self.selectedBeacon.major unsignedShortValue],
                           [self.selectedBeacon.minor unsignedShortValue]];
    
    
    // Make key from Major + Minor
    NSString *MajorMinor = [NSString stringWithFormat:
                            @"%i-%i",
                            [self.selectedBeacon.major unsignedShortValue],
                            [self.selectedBeacon.minor unsignedShortValue]];
    NSLog(@"NSString = %@", MajorMinor);
    
    // Starting Compare Plist
    [self comparePlist:(NSString*)MajorMinor withArray:self.keyDictionary];
    
    
    // Calculate the distance from Beacon
    NSString* beaconDistanceOne = [NSString stringWithFormat:
                                   @"Distance: %f",
                                   [self.selectedBeacon.distance floatValue]];
    NSLog(@"Nsstring = %@", beaconDistanceOne);
    self.beaconDistanceOne.text = beaconDistanceOne;
    
    // My Postion!
    // calculate and set new y position
    switch (self.selectedBeacon.proximity)
    {
        case CLProximityUnknown:
            labelText = [labelText stringByAppendingString: @"Unknown"];
            break;
        case CLProximityImmediate:
            labelText = [labelText stringByAppendingString: @"Sehr Nah"];
        case CLProximityNear:
            labelText = [labelText stringByAppendingString: @"in Sichtweite"];
            break;
        case CLProximityFar:
            labelText = [labelText stringByAppendingString: @"Weg"];
            break;
            
        default:
            break;
    }
    
    self.distanceLabel.text = labelText;
///////////////////////////////Beacon One/////////////////////////////////////
    
    
    
///////////////////////////////Beacon Two/////////////////////////////////////
    // Beacon Postion!
    // beacon array is sorted based on distanceˆ
    // closest beacon is the first one
    NSString* labelTextTwo = [NSString stringWithFormat:
                           @"Major: %i, Minor: %i\nRegion: ",
                           [self.selectedBeaconTwo.major unsignedShortValue],
                           [self.selectedBeaconTwo.minor unsignedShortValue]];
    
    
    // Make key from Major + Minor
    NSString *MajorMinorTwo = [NSString stringWithFormat:
                            @"%i-%i",
                            [self.selectedBeaconTwo.major unsignedShortValue],
                            [self.selectedBeaconTwo.minor unsignedShortValue]];
    NSLog(@"NSString = %@", MajorMinorTwo);
    
    // Starting Compare Plist
    [self comparePlist:(NSString*)MajorMinorTwo withArray:self.keyDictionary];
    
    
    // Calculate the distance from Beacon
    NSString* beaconDistanceTwo = [NSString stringWithFormat:
                                   @"Distance: %f",
                                   [self.selectedBeaconTwo.distance floatValue]];
    NSLog(@"Nsstring = %@", beaconDistanceTwo);
    self.beaconDistanceTwo.text = beaconDistanceTwo;
    
    // My Postion!
    // calculate and set new y position
    switch (self.selectedBeaconTwo.proximity)
    {
        case CLProximityUnknown:
            labelTextTwo = [labelTextTwo stringByAppendingString: @"Unknown"];
            break;
        case CLProximityImmediate:
            labelTextTwo = [labelTextTwo stringByAppendingString: @"Sehr Nah"];
        case CLProximityNear:
            labelTextTwo = [labelTextTwo stringByAppendingString: @"in Sichtweite"];
            break;
        case CLProximityFar:
            labelTextTwo = [labelTextTwo stringByAppendingString: @"Weg"];
            break;
            
        default:
            break;
    }
    
    self.distanceLabelTwo.text = labelTextTwo;
///////////////////////////////Beacon Two/////////////////////////////////////
    
    
    
///////////////////////////////Beacon Three/////////////////////////////////////
    // Beacon Postion!
    // beacon array is sorted based on distanceˆ
    // closest beacon is the first one
    NSString* labelTextThree = [NSString stringWithFormat:
                              @"Major: %i, Minor: %i\nRegion: ",
                              [self.selectedBeaconThree.major unsignedShortValue],
                              [self.selectedBeaconThree.minor unsignedShortValue]];
    
    
    // Make key from Major + Minor
    NSString *MajorMinorThree = [NSString stringWithFormat:
                               @"%i-%i",
                               [self.selectedBeaconThree.major unsignedShortValue],
                               [self.selectedBeaconThree.minor unsignedShortValue]];
    NSLog(@"NSString = %@", MajorMinorThree);
    
    // Starting Compare Plist
    [self comparePlist:(NSString*)MajorMinorThree withArray:self.keyDictionary];
    
    
    // Calculate the distance from Beacon
    NSString* beaconDistanceThree = [NSString stringWithFormat:
                                   @"Distance: %f",
                                   [self.selectedBeaconThree.distance floatValue]];
    NSLog(@"Nsstring = %@", beaconDistanceThree);
    self.beaconDistanceThree.text = beaconDistanceThree;
    
    // My Postion!
    // calculate and set new y position
    switch (self.selectedBeaconThree.proximity)
    {
        case CLProximityUnknown:
            labelTextThree = [labelTextThree stringByAppendingString: @"Unknown"];
            break;
        case CLProximityImmediate:
            labelTextThree = [labelTextThree stringByAppendingString: @"Sehr Nah"];
        case CLProximityNear:
            labelTextThree = [labelTextThree stringByAppendingString: @"in Sichtweite"];
            break;
        case CLProximityFar:
            labelTextThree = [labelTextThree stringByAppendingString: @"Weg"];
            break;
            
        default:
            break;
    }
    
    self.distanceLabelThree.text = labelTextThree;
///////////////////////////////Beacon Three/////////////////////////////////////
    
    
    
    
}


// Reading Plist.
-(void) readPlist
{
    NSDictionary *keyDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beaconLockMap" ofType:@"plist"]];
    NSLog(@"dictionary = %@", keyDictionary);
    self.keyDictionary = keyDictionary;
    
    
}

// Comparing Plist with Major + Minor.
-(void) comparePlist:(NSString*)MajorMinor withArray:(NSDictionary*)keyDictionary
{
    
    if ([keyDictionary objectForKey: MajorMinor])
    {
        NSLog(@"compare Done!");
        NSString *compareUrl = [keyDictionary valueForKey: MajorMinor];
        NSLog(@"KeyValue = %@", compareUrl);
        self.parsedUrl = compareUrl;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
