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
@synthesize address;

-(id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate address:(NSString*)_address {
    if (self = [super init]) {
        self.coordinate = _coordinate;
        self.address = _address;
        self.title = _address;
        self.subtitle = nil;
    }
    
    return self;
}

-(void)dealloc {
    [self.title release];
    [self.subtitle release];
    [self.address release];
    [super dealloc];
}

@end
