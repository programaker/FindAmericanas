//
//  AmericanasPlaceMarkRepository.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmericanasStoreFactory.h"
#import "AllAmericanasStoresDelegate.h"

@interface AllAmericanasStores : NSObject {

}

@property(nonatomic,retain) NSURLConnection* findStoresUrlConnection;
@property(nonatomic,retain) NSMutableData* foundStoresRawData;
@property(nonatomic,retain) AmericanasStoreFactory* americanasStoreFactory;
@property(nonatomic,retain) NSArray* storesFoundInSearch;
@property(nonatomic,retain) id<AllAmericanasStoresDelegate> delegate;

-(id)initWithDelegate:(id<AllAmericanasStoresDelegate>)_delegate;
-(void)findStoresNearLatitude:(double)latitude longitude:(double)longitude;

@end
