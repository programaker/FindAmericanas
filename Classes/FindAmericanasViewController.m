//
//  FindAmericanasViewController.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "FindAmericanasViewController.h"
#import "AmericanasStore.h"
#import "AmericanasMapPin.h"

@implementation FindAmericanasViewController

@synthesize mapView;
@synthesize americanasStoreRepository;
@synthesize userLocation;
@synthesize locationManager;


#pragma mark -
#pragma mark Lifecycle

- (void)dealloc {
    [self.mapView release];
    [self.americanasStoreRepository release];
    [super dealloc];
}


#pragma mark -
#pragma mark Internal

-(void)addStoresToMap {
    for (AmericanasStore* store in self.americanasStoreRepository.foundStores) {
        NSLog(@"+++ Adding loaded store:[%@] to map", store.title);
        [self.mapView addAnnotation:store];
    }
}

-(void)configureMap {
    CLLocationDegrees coordinateSpanDelta = 0.009;
    
    MKCoordinateSpan span;
	span.latitudeDelta = coordinateSpanDelta;
	span.longitudeDelta = coordinateSpanDelta;
    
    MKCoordinateRegion region;
	region.center = self.userLocation;	
	region.span = span;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
	[self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
}

-(void)configureLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark AmericanasStoreRepositoryDelegate

-(void)didCreateStore:(AmericanasStore*)store {
    NSLog(@"+++ Adding loaded store:[%@] to map", store.title);
    [self.mapView addAnnotation:store];
}


#pragma mark -
#pragma mark MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView*)map viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }

    NSLog(@"Creating annotation view for store:[%@]", annotation.title);
    
    AmericanasMapPin* annotationView = (AmericanasMapPin*)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"AmericanasPin"];
        
    if (!annotationView) {
        UIImage* americanasPinImage = [UIImage imageNamed:@"americanas-pin-icon.png"];
        annotationView = [[AmericanasMapPin alloc] initWithAnnotation:annotation image:americanasPinImage];
    }    
    
    return [annotationView autorelease];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager*)manager 
        didUpdateToLocation:(CLLocation*)newLocation 
        fromLocation:(CLLocation*)oldLocation {

    NSLog(@"Location updated");
    [self.locationManager stopUpdatingLocation];
    self.userLocation = newLocation.coordinate;
    [self configureMap];
    [self.americanasStoreRepository findStoresNearLatitude:self.userLocation.latitude longitude:self.userLocation.longitude];
}


#pragma mark -
#pragma mark View
								
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLocationManager];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
        selector:@selector(addStoresToMap) 
        name:@"didCreateAllStores" 
        object:nil];
        
    self.americanasStoreRepository = [[AmericanasStoreRepository alloc] initWithDelegate:self];
}

-(void)viewDidUnload {
    [self.americanasStoreRepository release];
}

@end
