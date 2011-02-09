//
//  AmericanasPlaceMarkRepository.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/8/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAmericanasStores : NSObject {

}

@property(nonatomic,retain) NSURLConnection* findStoresUrlConnection;
@property(nonatomic,retain) NSMutableData* foundStoresRawData;

-(NSArray*)foundedStores;
-(void)findStoresNearLatitude:(double)latitude longitude:(double)longitude;

@end
