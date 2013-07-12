//
//  HUDLayer.m
//  Box2D
//
//  Created by Sam Lee on 2013/06/20.
//
//

#import "HUDLayer.h"
#import "HelloWorldLayer.h"
#import "MenuLayer.h"
#import "SettingsManager.h"


@implementation HUDLayer

@synthesize paused;

-(id)init {
    
    if ((self = [super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial-hd.fnt"];
        } else {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        }
        _statusLabel.position = ccp(winSize.width* 0.85, winSize.height * 0.9);
        [self addChild:_statusLabel];
        [self createPauseButton];
        [self createPausedMenu];
    }
    return self;
}

- (void)setStatusString:(NSString *)string {
    _statusLabel.string = string;
}

- (void)pauseButtonWasPressed:(id)sender {

    [[SettingsManager sharedSettingsManager] logSettings];
    
    // pause the game
    paused = YES;
    
    // hide the pause button
    [pauseButton runAction:[CCFadeOut actionWithDuration:0.5]];
    
    // bring the sprite that shows the word 'Paused' into view
    [pausedSprite runAction:[CCMoveTo actionWithDuration:0.5
                                                position:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height/2+50)]];
    // bring the paued menu into view
    id move = [CCMoveTo actionWithDuration:0.5
                                  position:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height/2-100)];
//    id end = [[CCActionManager sharedManager] pauseAllRunningActions];
    
     [pausedMenu runAction:[CCSequence actions: move, nil]];

    
//    [pausedMenu runAction:[CCMoveTo actionWithDuration:0.5
//                                              position:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height/2-100)]];
    //[[CCActionManager sharedManager] pauseAllRunningActions];
}


- (void)createPauseButton {
    
    // create sprite for the pause button
    pauseButton = [CCSprite spriteWithFile:@"PauseButton.png"];
    
    // create menu item for the pause button from the pause sprite
    CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite:pauseButton
                                                     selectedSprite:nil
                                                             target:self
                                                           selector:@selector(pauseButtonWasPressed:)];
    
    // create menu for the pause button and put the menu item on the menu
    CCMenu *menu = [CCMenu menuWithItems: item, nil];
    [menu setAnchorPoint:ccp(0, 0)];
//    [menu setIsRelativeAnchorPoint:NO];
    [menu setPosition:ccp(30,30)];
//    [menu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height-16)];
    [menu setScale:0.3];
    [self addChild:menu];
}


-(void)createPausedMenu {
    
    // create a sprite that says simply 'Paused'
    pausedSprite = [CCSprite spriteWithFile:@"Paused.png"];
    
    // create the quit button
    CCMenuItemSprite *item1 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"QuitButton.png"]
                            selectedSprite:nil
                                    target:self selector:@selector(quitButtonWasPressed:)];
    CCLabelBMFont *quitFont = [CCLabelBMFont labelWithString:@"Quit" fntFile:@"Arial.fnt"];
    quitFont.scale = 0.5;
    [quitFont setAnchorPoint: ccp(-0.7f, 1.f)];
    [item1 addChild: quitFont];
    
    // create the restart button
    CCMenuItemSprite *item2 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"RestartButton.png"]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(restartButtonWasPressed:)];
    // create the resume button
    CCMenuItemSprite *item3 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"ResumeButton.png"]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(resumeButtonWasPressed:)];
    
    // put all those three buttons on the menu
    pausedMenu = [CCMenu menuWithItems:item1, item2, item3, nil];
    
    // align the menu
    [pausedMenu alignItemsInRows:
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     nil];
    
    // create the paused sprite and paused menu buttons off screen
    [pausedSprite setPosition:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height + 200)];
    [pausedMenu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, -300)];
    
    // add the Paused sprite and menu to the current layer
    [self addChild:pausedSprite z:100];
    [self addChild:pausedMenu z:100];
}


- (void)quitButtonWasPressed:(id)sender {
    [[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];
}

- (void)restartButtonWasPressed:(id)sender {
//    [SceneManager goGameScene];
//    HelloWorldLayer *layer = (HelloWorldLayer *)self.parent;
//    CCScene *temp = [[CCDirector sharedDirector] runningScene];
//    [[CCDirector sharedDirector] replaceScene:[layer scene]];
    NSLog(@"Restart");
}

- (void)resumeButtonWasPressed:(id)sender {
    // unpause the game
    paused = NO;
    
    // show the pause button
    [pauseButton runAction:[CCFadeIn actionWithDuration:0.5]];
    
    // hide the sprite that shows the word 'Paused' from view
    [pausedSprite runAction:[CCMoveTo actionWithDuration:0.5
                                                position:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height + 200)]];
    // hide the paued menu from view
    [pausedMenu runAction:[CCMoveTo actionWithDuration:0.5
                                              position:ccp([CCDirector sharedDirector].winSize.width/2, -300)]];
}


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
