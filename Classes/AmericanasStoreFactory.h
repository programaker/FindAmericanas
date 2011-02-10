//
//  AmericanasStoreFactory.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/9/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AmericanasStore.h"


@interface AmericanasStoreFactory : NSObject<NSXMLParserDelegate> {

}

@property(nonatomic,assign) NSSet* propertyNames;
@property(nonatomic,retain) NSMutableDictionary* storeProperties;
@property(nonatomic,retain) NSString* currentProperty;
@property(nonatomic,retain) NSMutableString* currentPropertyValue;
@property(nonatomic,retain) NSMutableArray* createdStores;

-(id)init;
-(NSArray*)createFrom:(NSData*)storesXmlData;

@end
