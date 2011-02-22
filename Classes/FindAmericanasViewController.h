//
//  FindAmericanasViewController.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AmericanasStoreRepository.h"
#import "AmericanasStoreRepositoryDelegate.h"

@interface FindAmericanasViewController : 
    UIViewController<MKMapViewDelegate,AmericanasStoreRepositoryDelegate,CLLocationManagerDelegate> {

}

@property(nonatomic,retain) IBOutlet MKMapView* mapView;
@property(nonatomic,readwrite) CLLocationCoordinate2D userLocation;
@property(nonatomic,retain) CLLocationManager* locationManager;
@property(nonatomic,retain) AmericanasStoreRepository* americanasStoreRepository;

@end

