#import "GameOverLayer.h"
#import "MenuLayer.h"
#import "HelloWorldLayer.h"

@implementation GameOverLayer



+(CCScene *) sceneWithWon:(BOOL)won{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
       
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Lose :[";
        }
        
        
        CCMenuItemFont *retry_button = [CCMenuItemFont itemWithString:@"Retry" target:self selector:@selector(retry:)];
        [retry_button.label setColor:ccc3(0, 0, 0)];
        
        CCMenuItemFont *quit_button = [CCMenuItemFont itemWithString:@"Return to menu" target:self selector:@selector(quit:)];
        [quit_button.label setColor:ccc3(0, 0, 0)];

        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2+50);
        [self addChild:label];
        
        CCMenu *menu = [CCMenu menuWithItems:retry_button, quit_button, nil];
        [menu alignItemsVertically];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            [menu setPosition:ccp( winSize.width/2, winSize.height/2 - 50)];
        } else {
            [menu setPosition:ccp( winSize.width/2, winSize.height/2 - 120)];
        }
        [self addChild:menu];

//        [self runAction:
//         [CCSequence actions:
//          [CCDelayTime actionWithDuration:3],
//          [CCCallBlockN actionWithBlock:^(CCNode *node) {
//             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
//         }],
//          nil]];
    }
    return self;
}




- (void) retry: (CCMenuItem  *) menuItem
{
    CCScene *scene = [HelloWorldLayer scene];
	[[CCDirector sharedDirector] replaceScene:scene];  
}

- (void) quit: (CCMenuItem  *) menuItem
{
	[[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];
    
}


@end