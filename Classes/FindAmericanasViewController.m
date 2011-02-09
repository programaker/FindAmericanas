//
//  FindAmericanasViewController.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "FindAmericanasViewController.h"
#import "AllAmericanasStores.h"
#import "AmericanasStore.h"
#import "AmericanasMapPin.h"

@implementation FindAmericanasViewController

@synthesize mapView;


#pragma mark -
#pragma mark Internal

-(void)addAmericanasStoresLocationsToMap {
    AllAmericanasStores* allAmericanasStores = [[AllAmericanasStores alloc] init];
    NSArray* americanasStores = [allAmericanasStores foundedStores];
    
    for (AmericanasStore* store in americanasStores) {
        [self.mapView addAnnotation:store];
    }
    
    [allAmericanasStores release];
}

-(void)configureMap {
    CLLocationCoordinate2D assembleiaStreet98;
    assembleiaStreet98.latitude = -22.905896; 
    assembleiaStreet98.longitude = -43.17811;
	
    CLLocationDegrees coordinateSpanDelta = 0.009;
    
    MKCoordinateSpan span;
	span.latitudeDelta = coordinateSpanDelta;
	span.longitudeDelta = coordinateSpanDelta;
    
    MKCoordinateRegion region;
	region.center = assembleiaStreet98;	
	region.span = span;
    
    [self addAmericanasStoresLocationsToMap];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
	[mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
}


#pragma mark -
#pragma mark MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView*)map viewForAnnotation:(id<MKAnnotation>)annotation {
    UIImage* americanasPinImage = [UIImage imageNamed:@"americanas-pin-icon.png"];
    AmericanasMapPin* annotationView = [[AmericanasMapPin alloc] initWithAnnotation:annotation image:americanasPinImage];    
    return [annotationView autorelease];
}


#pragma mark -
#pragma mark Others
								
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMap];
}

- (void)dealloc {
    [super dealloc];
}

@end
