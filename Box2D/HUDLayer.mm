//
//  HUDLayer.m
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "HUDLayer.h"
#import "HelloWorldLayer.h"


@implementation HUDLayer

@synthesize paused;

-(id)init {
    
    if ((self = [super init])) {
        
//        _dPad = [PauseButton dPadWithFile:@"Icon.png" radius:72];
//        _dPad.position = ccp(72.0, 72.0);
//        _dPad.opacity = 100;
//        [self addChild:_dPad];
//        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial-hd.fnt"];
        } else {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        }
        _statusLabel.position = ccp(winSize.width* 0.85, winSize.height * 0.9);
        [self addChild:_statusLabel];
        [self createPauseButton];
    }
    return self;
}

- (void)setStatusString:(NSString *)string {
    _statusLabel.string = string;
}

- (void)pauseButtonWasPressed:(id)sender {
     paused = YES;
    
    NSLog(@"hellow");
    NSLog(@"Is it: %@", paused? @"Yes":@"No");
}

-(BOOL)getPause{
    return paused;
}

- (void)createPauseButton {
    
    // create sprite for the pause button
    pauseButton = [CCSprite spriteWithFile:@"Icon.png"];
    
    // create menu item for the pause button from the pause sprite
    CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite:pauseButton
                                                     selectedSprite:nil
                                                             target:self
                                                           selector:@selector(pauseButtonWasPressed:)];
    
    // create menu for the pause button and put the menu item on the menu
    CCMenu *menu = [CCMenu menuWithItems: item, nil];
    [menu setAnchorPoint:ccp(0, 0)];
    [menu setIsRelativeAnchorPoint:NO];
    [menu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height-16)];
    [menu setScale:0.3];
    [self addChild:menu];
}


- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace:touch];
    location = [[CCDirector sharedDirector] convertToGL: location];
    if(location.y)
    {
        NSLog(@"hellow");
        return YES;
        //        [[CCDirector sharedDirector] pause];
    }
    // default to not consume touch
    return NO;
}

//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [touches anyObject];
//    CGPoint location = [touch locationInView:touch.view];
//    location = [[CCDirector sharedDirector] convertToGL: location];
//    if(location.y>20)
//    {
//        NSLog(@"Hello");
////        [[CCDirector sharedDirector] pause];
//    }
//}

- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    
}

- (void)showRestartMenu:(BOOL)won {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (won) {
        message = @"You win!";
    } else {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];
    } else {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
}

@end
