//
//  PauseButton.h
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "cocos2d.h"

@interface PauseButton : CCSprite <CCTargetedTouchDelegate>{
    float _radius;
}

+(id)dPadWithFile:(NSString *)fileName radius:(float)radius;
-(id)initWithFile:(NSString *)filename radius:(float)radius;

@end
