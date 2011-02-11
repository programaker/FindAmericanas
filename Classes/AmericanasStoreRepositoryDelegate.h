//
//  AmericanasStoreRepositoryDelegate.h
//  FindAmericanas
//
//  Created by Marcelo Gomes on 2/10/11.
//  Copyright 2011 Damage Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmericanasStore.h"


@protocol AmericanasStoreRepositoryDelegate

-(void)didCreateStore:(AmericanasStore*)store;
@end
