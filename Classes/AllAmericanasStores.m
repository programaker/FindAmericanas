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
@synthesize americanasStoreFactory;
@synthesize storesFoundInSearch;
@synthesize delegate;


#pragma mark -
#pragma mark Lifecycle

-(id)initWithDelegate:(id<AllAmericanasStoresDelegate>)_delegate {
    if (self = [super init]) {
        self.delegate = _delegate;
        self.americanasStoreFactory = [[AmericanasStoreFactory alloc] init];
    }
    
    return self;
}

-(void)dealloc {
    [self.findStoresUrlConnection release];
    [self.foundStoresRawData release];
    [self.americanasStoreFactory release];
    [self.storesFoundInSearch release];
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

-(void)findStoresNearLatitude:(double)latitude longitude:(double)longitude {
    self.foundStoresRawData = [NSMutableData data];
    
    NSString* googleMapsRequestUrl = [self buildUrlWithLatitude:latitude longitude:longitude];
    NSLog(@"Google Maps request URL:[%@]", googleMapsRequestUrl);
    
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
    NSLog(@"Finish loading Google Maps XML. %d bytes loaded", [self.foundStoresRawData bytes]);
	self.storesFoundInSearch = [self.americanasStoreFactory createFrom:self.foundStoresRawData];
    
    NSLog(@"%d stores created from XML", [self.storesFoundInSearch count]);
    [self.delegate didFinishLoadingStores:storesFoundInSearch];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"Error retrieving locations from Google Maps");
}

@end
