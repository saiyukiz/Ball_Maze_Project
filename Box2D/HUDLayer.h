//
//  HUDLayer.h
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "cocos2d.h"
#import "PauseButton.h"

@interface HUDLayer : CCLayer {
    CCLabelBMFont * _statusLabel;
    CCMenuItem *_label;
//    CCMenuItem * _statusLabel;
    PauseButton *_dPad;
    
    CCSprite *pauseButton;
    CCSprite *pausedSprite;
    CCMenu *pausedMenu;
    BOOL paused;
}

- (void)showRestartMenu:(BOOL)won;
- (void)setStatusString:(NSString *)string;
-(BOOL)getPause;

@property (assign) BOOL paused;




@end