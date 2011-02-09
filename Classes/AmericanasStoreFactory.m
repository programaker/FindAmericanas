//
//  AmericanasStoreFactory.m
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/9/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import "AmericanasStoreFactory.h"


@implementation AmericanasStoreFactory

@synthesize propertyNames;
@synthesize storeProperties;
@synthesize currentProperty;
@synthesize currentPropertyValue;
@synthesize createdStores;


#pragma mark -
#pragma mark Lifecycle

-(id)init {
	if (self = [super init]) {
		self.propertyNames = [[NSSet alloc] initWithObjects:@"name",@"description",@"imageUrl",nil];
	}
	
	return self;
}

-(void)dealloc {
	[self.propertyNames release];
	[self.currentPropertyValue release];
	[self.storeProperties release];
	[self.createdStores release];
	[self.currentProperty release];
	[super dealloc];
}


#pragma mark -
#pragma mark Services

-(NSArray*)createFrom:(NSData*)storesXmlData {

}


#pragma mark -
#pragma mark NSXMLParserDelegate

-(void)parser:(NSXMLParser*)parser 
        didStartElement:(NSString*)elementName 
        namespaceURI:(NSString*)namespaceURI 
        qualifiedName:(NSString*)qualifiedName 
        attributes:(NSDictionary*)attributeDict {
    
	
}

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)foundCharacters {
	
}

-(void)parser:(NSXMLParser*)parser
        didEndElement:(NSString*)elementName
        namespaceURI:(NSString*)namespaceURI
        qualifiedName:(NSString*)qualifiedName {
    
	
}

@end
