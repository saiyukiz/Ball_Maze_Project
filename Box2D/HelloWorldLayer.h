#import "cocos2d.h"

#import "GameObject.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"
#import "MyContactListener.h"
#import "HUDLayer.h"
#import "PauseButton.h"

@interface HelloWorldLayer : CCLayer {
    HUDLayer * _hud;
    BOOL hud_paused;
    
    b2World *_world;
    b2Body *_body;
    CCSprite *_ball;
    b2Body *_ballBody;
    b2Fixture *_ballFixture;
    b2Fixture *_monsterFixture;
    b2Body *_monsBody;
    b2Body *_wallBody;
    b2Fixture *_wallFixture;
    
    b2Fixture *_bottomFixture;
    
    NSMutableArray *_monsters;
    
    CCSprite *_snake;
    CCAction *_snakeAction;
    CCSprite *_croc;
    CCAction *_crocAction;
    
 
    MyContactListener *_contactListener;
    
    //CCAnimation *_ballAnimationFrames;
    NSArray * _ballAnimationFrames;
    CCAction *ballAction;
    CGPoint monsPos;
    CGPoint ballPos;
    CGSize monsSize;
    
    CCSpriteBatchNode *_spriteSheet;
    CCTMXObjectGroup *_objectGroup;
    NSDictionary *_spawnPoint;
    int mons_x;
    int mons_y;
    
    CCSprite *_hole;
    CGPoint holePos;
    CGSize holeSize;
    
    b2Body *_spriteBody;
    
    b2Vec2 _ballForce;

}

+ (id) scene;
- (id)initWithHUD:(HUDLayer *)hud;

@end