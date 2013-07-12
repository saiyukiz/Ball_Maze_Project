//
//  GameObject.h
//  Box2D
//
//  Created by Sam Lee on 2013/04/27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    GameObjectType  type;
}


@property (nonatomic, readwrite) GameObjectType type;

@end
