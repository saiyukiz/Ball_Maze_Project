//
//  PauseButton.m
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "PauseButton.h"

@implementation PauseButton

+(id)dPadWithFile:(NSString *)fileName radius:(float)radius {
    return [[self alloc] initWithFile:fileName radius:radius];
}

-(id)initWithFile:(NSString *)filename radius:(float)radius {
    if ((self = [super initWithFile:filename])) {
        _radius = radius;
        
    }
    return self;
}


-(void)onEnterTransitionDidFinish {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(void) onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    location = [[CCDirector sharedDirector] convertToGL: location];
    if(location.y < 60 )
    {
        NSLog(@"hellow");
        return YES;
        [[CCDirector sharedDirector] pause];
    }
    // default to not consume touch
    return NO;
}



@end
