//
//  HUDLayer.h
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    
    CCLabelBMFont * _statusLabel;
    CCMenuItem *_label;
    
    CCSprite *pauseButton;
    CCSprite *pausedSprite;
    CCMenu *pausedMenu;
    BOOL paused;
    
}

- (void)showRestartMenu:(BOOL)won;
- (void)setStatusString:(NSString *)string;


@property (assign) BOOL paused;


@end