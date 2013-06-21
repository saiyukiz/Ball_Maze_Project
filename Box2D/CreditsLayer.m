//
//  CreditsLayer.m
//  Ballmaze
//
//  Created by Mingjing Huang on 5/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CreditsLayer.h"
#import "MenuLayer.h"
#import "CCTouchDispatcher.h"

// CreditsLayer implementation
@implementation CreditsLayer

// Helper class method that creates a Scene with the CreditsLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsLayer *layer = [CreditsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        // create and initialize a Label
        float bigFontSize;
        float smallFontSize;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            bigFontSize = 50;
            smallFontSize = 20;
        } else {
            bigFontSize = 120;
            smallFontSize = 50;
        }
        CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Credits" fontName:@"Marker Felt" fontSize:bigFontSize];
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Sam: Coordinator" fontName:@"Marker Felt" fontSize:smallFontSize];
        CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Peter: Animation" fontName:@"Marker Felt" fontSize:smallFontSize];
        CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"Cameron: Audio" fontName:@"Marker Felt" fontSize:smallFontSize];
        CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"Jenny: Interface" fontName:@"Marker Felt" fontSize:smallFontSize];
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // position the label on the center of the screen
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            label1.position =  ccp( size.width /2, size.height - 50);
            label2.position =  ccp( size.width /2, size.height - 100);
            label3.position =  ccp( size.width /2, size.height - 140);
            label4.position =  ccp( size.width /2, size.height - 180);
            label5.position =  ccp( size.width /2, size.height - 220);
        } else {
            label1.position =  ccp( size.width /2, size.height - 120);
            label2.position =  ccp( size.width /2, size.height - 240);
            label3.position =  ccp( size.width /2, size.height - 320);
            label4.position =  ccp( size.width /2, size.height - 400);
            label5.position =  ccp( size.width /2, size.height - 480);
        }
        
        // add the label as a child to this Layer
        [self addChild: label1];
        [self addChild: label2];
        [self addChild: label3];
        [self addChild: label4];
        [self addChild: label5];
        
		// "Return" Menu Item
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [CCMenuItemFont setFontSize:18];
        } else {
            [CCMenuItemFont setFontSize:45];
        }
		CCMenuItem *itemReturn = [CCMenuItemFont itemWithString:@"Return" target:self selector:@selector(returnMenu:)];
		
		CCMenu *menu = [CCMenu menuWithItems:itemReturn, nil];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [menu setPosition:ccp( size.width - 40, 30)];
        } else {
            [menu setPosition:ccp( size.width - 100, 75)];
        }
		
		// Add the menu to the layer
		[self addChild: menu];
        
        self.isTouchEnabled=YES;
	}
    
    return self;
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) returnMenu: (CCMenuItem  *) menuItem
{
	//NSLog(@"The return item was called");
    [[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];
    //[[CCDirector sharedDirector] popScene];
}


@end
