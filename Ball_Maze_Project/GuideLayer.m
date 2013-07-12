//
//  GuideLayer.m
//  Ballmaze
//
//  Created by Mingjing Huang on 5/17/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GuideLayer.h"
#import "MenuLayer.h"
#import "CCTouchDispatcher.h"

// GuideLayer implementation
@implementation GuideLayer


// Helper class method that creates a Scene with the CreditsLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GuideLayer *layer = [GuideLayer node];
	
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
        CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"How to play" fontName:@"Marker Felt" fontSize:bigFontSize];
        
        // Define your text
        NSString *txt = @"Welcome to our awesome ball maze game! Click 'Start', then you are in the right place. Just manipulate your iPhone or iPad to move your ball. Beware of those monsters on your way, they will kill you if your ball hit them. Try to reach the hole on the right of the beginning point. You will win when your ball get into it. Click 'Return' on the right bottom corner if you want to go back. Let's go!";
        
        
        // ask director for the window size
        CGSize maxSize = [[CCDirector sharedDirector] winSize];		// Start off with an actual width and a height.
        
        // Calculate the actual size of the text with the font, size and line break mode.
        CGSize actualSize = [txt sizeWithFont:[UIFont fontWithName:@"Marker Felt" size:smallFontSize] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
        
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:txt dimensions:actualSize hAlignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"Marker Felt" fontSize:smallFontSize];
        
        // position the label on the center of the screen
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            label1.position =  ccp( maxSize.width /2, maxSize.height - 50);
            label2.position =  ccp( maxSize.width /2, maxSize.height /2);
        } else {
            label1.position =  ccp( maxSize.width /2, maxSize.height - 120);
            label2.position =  ccp( maxSize.width /2, maxSize.height /2);
        }
        
        // add the label as a child to this Layer
        [self addChild: label1];
        [self addChild: label2];
        
        
        // "Return" Menu Item
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [CCMenuItemFont setFontSize:18];
        } else {
            [CCMenuItemFont setFontSize:45];
        }
		CCMenuItem *itemReturn = [CCMenuItemFont itemWithString:@"Return" target:self selector:@selector(returnMenu:)];
		
		CCMenu *menu = [CCMenu menuWithItems:itemReturn, nil];
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [menu setPosition:ccp( maxSize.width - 40, 30)];
        } else {
            [menu setPosition:ccp( maxSize.width - 100, 75)];
        }
		
		// Add the menu to the layer
		[self addChild: menu];
        
        self.isTouchEnabled=YES;
	}
    
    return self;
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

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}


- (void) returnMenu: (CCMenuItem  *) menuItem
{
	//NSLog(@"The return item was called");
    [[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];
}


@end
