//
//  AmericanasMapPin.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AmericanasMapPin.h"


@implementation AmericanasMapPin

-(id)initWithAnnotation:(id<MKAnnotation>)_annotation image:(UIImage*)_image {
    self = [super initWithAnnotation:_annotation reuseIdentifier:@"AmericanasPin"];
    
    if (self) {
        self.image = _image;
        self.canShowCallout = YES;
        self.calloutOffset = CGPointMake(0, 0);
    }
    
    return self;
}

@end
