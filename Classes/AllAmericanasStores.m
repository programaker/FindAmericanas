//
//  AmericanasPlaceMarkRepository.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AllAmericanasStores.h"
#import "AmericanasStore.h"


@implementation AllAmericanasStores

+(NSArray*)findStores {
    NSMutableArray* allStores = [[NSMutableArray alloc] init];  
    
    AmericanasStore* ouvidorStore = [[AmericanasStore alloc] 
        initWithCoordinate:CLLocationCoordinate2DMake(-22.90415, -43.17996) 
        address:@"Rua do Ouvidor, nº 175"];
        
    AmericanasStore* passeioStore = [[AmericanasStore alloc] 
        initWithCoordinate:CLLocationCoordinate2DMake(-22.91201, -43.17663) 
        address:@"Rua do Passeio, nº 42"];
    
    [allStores addObject:[ouvidorStore autorelease]];
    [allStores addObject:[passeioStore autorelease]];
    
    return [allStores autorelease];
}

@end
