//
//  AmericanasStoreRepository.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/10/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AmericanasStoreRepository.h"


@implementation AmericanasStoreRepository

@synthesize delegate;

@synthesize findStoresUrlConnection;
@synthesize foundStoresRawData;

@synthesize xmlParser;
@synthesize propertyNames;
@synthesize storeProperties;
@synthesize currentProperty;
@synthesize currentPropertyValue;


#pragma mark -
#pragma mark Lifecycle

-(id)initWithDelegate:(id<AmericanasStoreRepositoryDelegate>)_delegate {
    self = [super init];
    
    if (self) {
        self.propertyNames = [[NSSet alloc] initWithObjects:@"name",@"address",@"coordinates",nil];
        self.delegate = _delegate;
    }
    
    return self;
}

-(void)dealloc {
    [self.findStoresUrlConnection release];
    [self.foundStoresRawData release];
    
    [self.xmlParser release];
	[self.propertyNames release];
	[self.currentPropertyValue release];
	[self.storeProperties release];
	[self.currentProperty release];
    
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

-(CLLocationCoordinate2D)parseCoordinates:(NSString*)coordinatesFromGoogleMaps {
    NSArray* splittedCoordinates = [coordinatesFromGoogleMaps componentsSeparatedByString:@","];
    
    NSString* latitudeString = [splittedCoordinates objectAtIndex:0];
    NSString* longitudeString = [splittedCoordinates objectAtIndex:1];
    
    double latitude = [latitudeString doubleValue];
    double longitude = [longitudeString doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
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

-(void)findMockStores {
    NSLog(@"Creating mock stores");

    AmericanasStore* ouvidorStore = [[AmericanasStore alloc] 	
         initWithCoordinate:CLLocationCoordinate2DMake(-22.90415, -43.17996) 
         name:@"Lojas Americanas Ouvidor"	
         address:@"Rua do Ouvidor, nº 175"];
         
    [self.delegate didCreateStore:[ouvidorStore autorelease]];
    
    AmericanasStore* passeioStore = [[AmericanasStore alloc] 	
         initWithCoordinate:CLLocationCoordinate2DMake(-22.91201, -43.17663) 	
         name:@"Lojas Americanas Passeio"
         address:@"Rua do Passeio, nº 42"];
         
    [self.delegate didCreateStore:[passeioStore autorelease]];
}


#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)receivedData {
    [self.foundStoresRawData appendData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"Finish loading Google Maps XML");    
	self.xmlParser = [[NSXMLParser alloc] initWithData:self.foundStoresRawData];
    [self.xmlParser setDelegate:self];
	[self.xmlParser parse];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"Error retrieving locations from Google Maps");
}


#pragma mark -
#pragma mark NSXMLParserDelegate

-(void)parserDidStartDocument:(NSXMLParser*)parser {
    NSLog(@"### Start xml document parsing");
}

-(void)parser:(NSXMLParser*)parser 
        didStartElement:(NSString*)elementName 
        namespaceURI:(NSString*)namespaceURI 
        qualifiedName:(NSString*)qualifiedName 
        attributes:(NSDictionary*)attributeDict {
    
    if ([@"Placemark" isEqualToString:elementName]) {
		self.storeProperties = [[NSMutableDictionary alloc] init];
	}
	else if ([propertyNames containsObject:elementName]) {
		self.currentProperty = elementName;
		self.currentPropertyValue = [[NSMutableString alloc] init];
	}
}

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)foundCharacters {
	if ([propertyNames containsObject:currentProperty]) {
		NSString* sanitizedString = [foundCharacters stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];		
		
        [currentPropertyValue appendString:sanitizedString];
	}
}

-(void)parser:(NSXMLParser*)parser
        didEndElement:(NSString*)elementName
        namespaceURI:(NSString*)namespaceURI
        qualifiedName:(NSString*)qualifiedName {
    
    if ([@"Placemark" isEqualToString:elementName]) {
		CLLocationCoordinate2D storeCoordinates = [self parseCoordinates:[storeProperties valueForKey:@"coordinates"]];
		
		AmericanasStore* newStore = [[AmericanasStore alloc] 
            initWithCoordinate:storeCoordinates
            name:[storeProperties valueForKey:@"name"]
            address:[storeProperties valueForKey:@"address"]];
		
		[self.delegate didCreateStore:[newStore autorelease]];
		[self.storeProperties release];
	}
	else if ([propertyNames containsObject:elementName]) {
		[self.storeProperties setValue:currentPropertyValue forKey:elementName];
		[self.currentPropertyValue release];
	}
}

-(void)parserDidEndDocument:(NSXMLParser*)parser {
    NSLog(@"### End xml document parsing");
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
    NSLog(@"Parse error with code:[%i]", [parseError code]);
}

@end
