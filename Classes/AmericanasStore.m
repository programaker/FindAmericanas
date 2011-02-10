//
//  AmericanasPlaceMark.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AmericanasStore.h"


@implementation AmericanasStore

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate name:(NSString*)_name address:(NSString*)_address {
    if (self = [super init]) {
        self.coordinate = _coordinate;
        self.title = _name;
        self.subtitle = _address;
    }
    
    return self;
}

-(void)dealloc {
    [self.title release];
    [self.subtitle release];
    [super dealloc];
}

@end
