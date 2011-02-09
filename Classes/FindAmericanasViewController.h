//
//  FindAmericanasViewController.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/3/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface FindAmericanasViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate> {

}

@property(nonatomic,retain) IBOutlet MKMapView* mapView;

@end

