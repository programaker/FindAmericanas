//
//  AmericanasMapPin.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface AmericanasMapPin : MKAnnotationView {

}

-(id)initWithAnnotation:(id<MKAnnotation>)_annotation image:(UIImage*)_image;

@end
