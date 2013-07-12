#import "cocos2d.h"

#import "GameObject.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"
#import "MyContactListener.h"
#import "HUDLayer.h"
#import "GameOverLayer.h"


@interface HelloWorldLayer : CCLayer {
    //hud
    HUDLayer *_hud;
    BOOL hud_paused;
    
    
    //general world attributes
    b2World *_world;
    b2Body *_body;
    b2Vec2 _ballForce;
    
    //collision listener
    MyContactListener *_contactListener;
    
    b2Body *_wallBody;
    b2Fixture *_wallFixture;
    b2Fixture *_bottomFixture;
    
    b2Body *_spriteBody;
    
    
    
    b2Fixture *_monsterFixture;
    b2Body *_monsBody;
 
    //array to store monsters
    NSMutableArray *_monsters;
    
    CCSpriteBatchNode *_spriteSheet;
    CCTMXObjectGroup *_objectGroup;
    NSDictionary *_spawnPoint;
    
    //monster sprites & their actions
    CCSprite *_bear;
    CCAction *_bearAction;
    CCSprite *_snake;
    CCAction *_snakeAction;
    CCSprite *_croc;
    CCAction *_crocAction;
 
    CGPoint monsPos;
    CGSize monsSize;
    int mons_x;
    int mons_y;
 
    
    //ball attributes
    //CCAnimation *_ballAnimationFrames;
    NSArray * _ballAnimationFrames;
    CCAction *ballAction;
    CGPoint ballPos;
    
    CCSprite *_ball;
    b2Body *_ballBody;
    b2Fixture *_ballFixture;
    
    //hole attributes
    CCSprite *_hole;
    CGPoint holePos;
    CGSize holeSize;
}

- (id) scene;
- (id)initWithHUD:(HUDLayer *)hud;

@end