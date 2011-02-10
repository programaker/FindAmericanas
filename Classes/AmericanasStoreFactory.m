//
//  AmericanasStoreFactory.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/9/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AmericanasStoreFactory.h"


@implementation AmericanasStoreFactory

@synthesize xmlParser;
@synthesize propertyNames;
@synthesize storeProperties;
@synthesize currentProperty;
@synthesize currentPropertyValue;
@synthesize createdStores;


#pragma mark -
#pragma mark Lifecycle

-(id)init {
	if (self = [super init]) {
		self.propertyNames = [[NSSet alloc] initWithObjects:@"name",@"address",@"coordinates",nil];
	}
	
	return self;
}

-(void)dealloc {
    [self.xmlParser release];
	[self.propertyNames release];
	[self.currentPropertyValue release];
	[self.storeProperties release];
	[self.createdStores release];
	[self.currentProperty release];
	[super dealloc];
}


#pragma mark -
#pragma mark Internal

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

-(NSArray*)createFrom:(NSData*)storesXmlData {
    self.createdStores = [[NSMutableArray alloc] init];
    
	self.xmlParser = [[NSXMLParser alloc] initWithData:storesXmlData];
    [self.xmlParser setDelegate:self];
	[self.xmlParser parse];
		
	return [self.createdStores autorelease];
}


#pragma mark -
#pragma mark NSXMLParserDelegate

-(void)parserDidStartDocument:(NSXMLParser*)parser {
    NSLog(@"Start parsing de xml document");
}

-(void)parser:(NSXMLParser*)parser 
        didStartElement:(NSString*)elementName 
        namespaceURI:(NSString*)namespaceURI 
        qualifiedName:(NSString*)qualifiedName 
        attributes:(NSDictionary*)attributeDict {
    
    NSLog(@"Starting element:[%@]", elementName);
    
	if ([@"Placemark" isEqualToString:elementName]) {
		NSLog(@"Starting a store");
		self.storeProperties = [[NSMutableDictionary alloc] init];
	}
	else if ([propertyNames containsObject:elementName]) {
		NSLog(@"Starting property:[%@]", elementName);
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
    
    NSLog(@"Ending element:[%@]", elementName);
    
	if ([@"Placemark" isEqualToString:elementName]) {
		NSLog(@"Ending the store");        
        CLLocationCoordinate2D storeCoordinates = [self parseCoordinates:[storeProperties valueForKey:@"coordinates"]];
		
		AmericanasStore* newStore = [[AmericanasStore alloc] 
            initWithCoordinate:storeCoordinates
            name:[storeProperties valueForKey:@"name"]
            address:[storeProperties valueForKey:@"address"]];
		
		[self.createdStores addObject:[newStore autorelease]];
		[self.storeProperties release];
	}
	else if ([propertyNames containsObject:elementName]) {
		NSLog(@"Ending property:[%@]", elementName);
		[self.storeProperties setValue:currentPropertyValue forKey:elementName];
		[self.currentPropertyValue release];
	}
}

-(void)parserDidEndDocument:(NSXMLParser*)parser {
    NSLog(@"End parsing xml document");
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
    NSLog(@"Parse error with code:[%i]", [parseError code]);
}

@end
