//
//  AmericanasPlaceMark.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>  

@interface AmericanasStore : NSObject<MKAnnotation> {

}

@property(nonatomic,readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate name:(NSString*)_name address:(NSString*)_address;

@end
