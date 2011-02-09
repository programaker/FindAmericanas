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

@synthesize findStoresUrlConnection;
@synthesize foundStoresRawData;


#pragma mark -
#pragma mark Lifecycle

-(void)dealloc {
    [self.findStoresUrlConnection release];
    [self.foundStoresRawData release];
    [super dealloc];
}


#pragma mark -
#pragma mark Internal

-(NSString*)buildUrlWithLatitude:(double)latitude longitude:(double)longitude {
    NSString* query = @"Lojas%20Americanas";
    NSString* searchTypeYellowPages = @"yp";
    NSString* searchNearLatitudeLongitude = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
    NSString* responseOutputInXml = @"kml";
    
    NSString* googleMapsUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@&mrt=%@&sll=%@&output=%@",
        query,
        searchTypeYellowPages,
        searchNearLatitudeLongitude,
        responseOutputInXml];
    
    return googleMapsUrl;
}


#pragma mark -
#pragma mark Services

-(NSArray*)foundedStores {
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

-(void)findStoresNearLatitude:(double)latitude longitude:(double)longitude {
    self.foundStoresRawData = [NSMutableData data];
    
    NSString* googleMapsRequestUrl = [self buildUrlWithLatitude:latitude longitude:longitude];
    NSURL* url = [NSURL URLWithString:googleMapsRequestUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    self.findStoresUrlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)receivedData {
	[self.foundStoresRawData appendData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
		
}

@end
