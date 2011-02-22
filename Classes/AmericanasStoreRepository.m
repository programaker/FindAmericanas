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

@synthesize foundStores;


#pragma mark -
#pragma mark Lifecycle

-(id)initWithDelegate:(id<AmericanasStoreRepositoryDelegate>)_delegate {
    self = [super init];
    
    if (self) {
        isInsidePlacemarkTag = NO;
        self.propertyNames = [[NSSet alloc] initWithObjects:@"name",@"address",@"coordinates",nil];
        self.foundStores = [[NSMutableArray alloc] init];
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
    
    [self.foundStores release];
    
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
         
    //[self.delegate didCreateStore:[ouvidorStore autorelease]];
    
    AmericanasStore* passeioStore = [[AmericanasStore alloc] 	
         initWithCoordinate:CLLocationCoordinate2DMake(-22.91201, -43.17663) 	
         name:@"Lojas Americanas Passeio"
         address:@"Rua do Passeio, nº 42"];
         
    //[self.delegate didCreateStore:[passeioStore autorelease]];
    
    [self.foundStores addObject:[ouvidorStore autorelease]];
    [self.foundStores addObject:[passeioStore autorelease]];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didCreateAllStores" object:nil];
}


#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)receivedData {
    [self.foundStoresRawData appendData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"Finish loading Google Maps XML");   
    [self.foundStores removeAllObjects];
      
	self.xmlParser = [[NSXMLParser alloc] initWithData:self.foundStoresRawData];
    [self.xmlParser setDelegate:self];
	[self.xmlParser parse];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"Error retrieving locations from Google Maps");
    [self.foundStores removeAllObjects];
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
        isInsidePlacemarkTag = YES;
        self.storeProperties = [[NSMutableDictionary alloc] init];
	}
	else if (isInsidePlacemarkTag && [propertyNames containsObject:elementName]) {
		self.currentProperty = elementName;
		self.currentPropertyValue = [[NSMutableString alloc] init];
	}
}

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)foundCharacters {
	if (isInsidePlacemarkTag && [self.propertyNames containsObject:self.currentProperty]) {
		NSString* sanitizedString = [foundCharacters stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        NSLog(@"Adding value:[%@]\nto property:[%@]\n",sanitizedString,self.currentProperty);
        [self.currentPropertyValue appendString:sanitizedString];
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
            
        NSLog(@"Created %@",newStore);
		
        [self.foundStores addObject:[newStore autorelease]];
		//[self.delegate didCreateStore:[newStore autorelease]];
		[self.storeProperties release];
        isInsidePlacemarkTag = NO;
	}
	else if (isInsidePlacemarkTag && [propertyNames containsObject:elementName]) {
        //NSLog(@"<%@>%@</%@>",elementName,self.currentPropertyValue,elementName);
		[self.storeProperties setValue:self.currentPropertyValue forKey:elementName];
		[self.currentPropertyValue release];
	}
}

-(void)parserDidEndDocument:(NSXMLParser*)parser {
    NSLog(@"### End xml document parsing");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didCreateAllStores" object:nil];
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
    NSLog(@"Parse error with code:[%i]", [parseError code]);
}

@end
