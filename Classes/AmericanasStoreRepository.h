//
//  AmericanasStoreRepository.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/10/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmericanasStoreRepositoryDelegate.h"


@interface AmericanasStoreRepository : NSObject<NSXMLParserDelegate> {

}

@property(nonatomic,retain) id<AmericanasStoreRepositoryDelegate> delegate;

@property(nonatomic,retain) NSURLConnection* findStoresUrlConnection;
@property(nonatomic,retain) NSMutableData* foundStoresRawData;

@property(nonatomic,retain) NSXMLParser* xmlParser;
@property(nonatomic,assign) NSSet* propertyNames;
@property(nonatomic,retain) NSMutableDictionary* storeProperties;
@property(nonatomic,retain) NSString* currentProperty;
@property(nonatomic,retain) NSMutableString* currentPropertyValue;

-(id)initWithDelegate:(id<AmericanasStoreRepositoryDelegate>)_delegate;
-(void)findStoresNearLatitude:(double)latitude longitude:(double)longitude;
-(void)findMockStores;

@end
