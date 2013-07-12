//
//  HelloWorldLayer.m
//  Ballmaze
//
//  Created by Mingjing Huang on 5/16/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "MenuLayer.h"
#import "CreditsLayer.h"
#import "GuideLayer.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

//#pragma mark - HelloWorldLayer

CCSprite *seeker1;

// HelloWorldLayer implementation
@implementation MenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
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
        
        // create and initialize our seeker sprite, and add it to this layer
        seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            seeker1.position = ccp( 20, 40 );
        } else {
            seeker1.position = ccp( 50, 100 );
        }
        [self addChild:seeker1];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
		
		// create and initialize a Label
        float fontSize;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            fontSize = 50;
        } else {
            fontSize = 120;
        }
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:fontSize];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            label.position =  ccp( size.width /2, size.height/2 + 50);
        } else {
            label.position =  ccp( size.width /2, size.height/2 + 120);
        }
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// "Start", "How to play" and "Credits"
		//
		
		// Default font size will be 28 points.
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [CCMenuItemFont setFontSize:25];
        } else {
            [CCMenuItemFont setFontSize:60];
        }
		
		// "Start" Menu Item using blocks
		CCMenuItem *itemStart = [CCMenuItemFont itemWithString:@"Start" target:self selector:@selector(startGame:)];
        
		// "How to play" Menu Item using blocks
		CCMenuItem *itemGuide = [CCMenuItemFont itemWithString:@"How to play" target:self selector:@selector(howToPlay:)];
        
        // "Credits" Menu Item using blocks
		CCMenuItem *itemCredits = [CCMenuItemFont itemWithString:@"Credits" target:self selector:@selector(showCredits:)];
		
		CCMenu *menu = [CCMenu menuWithItems:itemStart, itemGuide, itemCredits, nil];
		[menu alignItemsVertically];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        } else {
            [menu setPosition:ccp( size.width/2, size.height/2 - 120)];
        }
		
		// Add the menu to the layer
		[self addChild:menu];
        
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

- (void) nextFrame:(ccTime)dt {
    seeker1.position = ccp( seeker1.position.x + 100*dt, seeker1.position.y );
    CGSize size = [[CCDirector sharedDirector] winSize];
    if (seeker1.position.x > size.width+32) {
        seeker1.position = ccp( -32, seeker1.position.y );
    }
}

- (void) startGame: (CCMenuItem  *) menuItem
{
	//NSLog(@"The first item was called");
    [[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
}
- (void) howToPlay: (CCMenuItem  *) menuItem
{
	//NSLog(@"The second item was called");
    [[CCDirector sharedDirector] replaceScene: [GuideLayer scene]];
}
- (void) showCredits: (CCMenuItem  *) menuItem
{
	//NSLog(@"The third item was called");
    [[CCDirector sharedDirector] replaceScene: [CreditsLayer scene]];
}

@end
