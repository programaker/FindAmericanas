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
@synthesize allAmericanasStores;
@synthesize mockUserLocation;


#pragma mark -
#pragma mark Internal

-(void)configureMap {
    CLLocationDegrees coordinateSpanDelta = 0.009;
    
    MKCoordinateSpan span;
	span.latitudeDelta = coordinateSpanDelta;
	span.longitudeDelta = coordinateSpanDelta;
    
    MKCoordinateRegion region;
	region.center = self.mockUserLocation;	
	region.span = span;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
	[mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
}


#pragma mark -
#pragma mark AllAmericanasStoresDelegate

-(void)didFinishLoadingStores:(NSArray*)stores {
    for (AmericanasStore* store in stores) {
        NSLog(@"Adding loaded store:[%@] to map", store.title);
        [self.mapView addAnnotation:store];
    }
}


#pragma mark -
#pragma mark MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView*)map viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"Creating annotation view for store:[%@]", annotation.title);

    UIImage* americanasPinImage = [UIImage imageNamed:@"americanas-pin-icon.png"];
    AmericanasMapPin* annotationView = [[AmericanasMapPin alloc] initWithAnnotation:annotation image:americanasPinImage];    
    return [annotationView autorelease];
}


#pragma mark -
#pragma mark Others
								
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D assembleiaStreet98;
    assembleiaStreet98.latitude = -22.905896; 
    assembleiaStreet98.longitude = -43.17811;    
    self.mockUserLocation = assembleiaStreet98;
    
    [self configureMap];
    self.allAmericanasStores = [[AllAmericanasStores alloc] initWithDelegate:self];
    [self.allAmericanasStores findStoresNearLatitude:assembleiaStreet98.latitude longitude:assembleiaStreet98.longitude];
}

-(void)viewDidUnload {
    [self.allAmericanasStores release];
}


#pragma mark -
#pragma mark Lifecycle

- (void)dealloc {
    [self.mapView release];
    [self.allAmericanasStores release];
    [super dealloc];
}

@end
