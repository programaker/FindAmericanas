//
//  FindAmericanasViewController.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AllAmericanasStoresDelegate.h"
#import "AllAmericanasStores.h"


@interface FindAmericanasViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,AllAmericanasStoresDelegate> {

}

@property(nonatomic,retain) IBOutlet MKMapView* mapView;
@property(nonatomic,readwrite) CLLocationCoordinate2D mockUserLocation;
@property(nonatomic,retain) AllAmericanasStores* allAmericanasStores;

@end

