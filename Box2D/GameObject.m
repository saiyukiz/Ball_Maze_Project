//
//  GameObject.m
//  Box2D
//
//  Created by Sam Lee on 2013/04/27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        type = kGameObjectNone;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
