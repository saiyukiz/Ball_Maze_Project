#import "HelloWorldLayer.h"
#import "GameOverLayer.h"


@interface HelloWorldLayer()
@property (strong) CCTMXTiledMap *tileMap;
@property (strong) CCTMXLayer *background;

//@property (nonatomic, strong) CCSprite *bear;
//@property (nonatomic, strong) CCAction *bearAction;

@end
// cam
// viteetarm
//peter
//COSC345 suck balls
//hahaha


@implementation HelloWorldLayer

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:1];
    
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initWithHUD:hud] autorelease];
    [scene addChild:layer];
    return scene;
    
}

//initialization
- (id)initWithHUD:(HUDLayer *)hud{
    
    if ((self=[super init])) {
        _hud = hud;
                   
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
    
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"win2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"death1.wav"];
        
        [self setViewPointCenter:_ball.position];
        
        
        //load map and background layer
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"Trial_Map.tmx"];
        self.background = [_tileMap layerNamed:@"BackGround"];
        //_tileMap.anchorPoint = ccp(0, 0);
        
        //object group layer
        _objectGroup = [_tileMap objectGroupNamed:@"spawnpoint"];
        NSAssert(_objectGroup != nil, @"tile map has no objects object layer");
        
        
        //inserts monsters into an array
        _monsters = [[NSMutableArray alloc] init];

        
        //define world physics gravity and physics related things for collisions
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        _world = new b2World(gravity);
        

        //create edges around screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        //screen edge definitions
        groundEdge.Set(b2Vec2(0,0),b2Vec2(_tileMap.mapSize.width * (_tileMap.tileSize.width/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0, _tileMap.mapSize.height * (_tileMap.tileSize.height/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(0,_tileMap.mapSize.height * (_tileMap.tileSize.height/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO), b2Vec2(_tileMap.mapSize.width * (_tileMap.tileSize.width/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO, _tileMap.mapSize.height * (_tileMap.tileSize.height/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        
        groundEdge.Set(b2Vec2(_tileMap.mapSize.width * (_tileMap.tileSize.width/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO, _tileMap.mapSize.height * (_tileMap.tileSize.height/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO), b2Vec2(_tileMap.mapSize.width * (_tileMap.tileSize.width/CC_CONTENT_SCALE_FACTOR())/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        
        //contact listener 
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        
        [self addChild:_tileMap z:-1];
        [self drawCollisionTiles];
        [self spawnHole];
        [self spawnBall];
        [self spawnBear];
        [self spawnSnake];
        [self spawnCroc];
        [self schedule:@selector(tick:)];
      
    }    
    return self;
}


//puts ball on screen
- (void)spawnBall {
    CCSpriteFrameCache * cache = [CCSpriteFrameCache sharedSpriteFrameCache];
     [cache addSpriteFramesWithFile:@"ball_falling_anim.plist" textureFilename:@"ball_falling_anim.png"];
    
    NSMutableArray *ballFrames = [NSMutableArray array];
    for(NSInteger i =1; i<15; i++) {
            [ballFrames addObject:[cache spriteFrameByName:[NSString stringWithFormat:@"ball-%i.png", i]]];
    }
    
    _ballAnimationFrames = [NSArray arrayWithArray:ballFrames];
    [_ballAnimationFrames retain];
    
    NSDictionary *spawnPoint = [_objectGroup objectNamed:@"player"];
    int ball_x = [spawnPoint [@"x"]integerValue]/CC_CONTENT_SCALE_FACTOR();
    int ball_y = [spawnPoint [@"y"] integerValue]/CC_CONTENT_SCALE_FACTOR();
    

    
    _ball = [CCSprite spriteWithSpriteFrameName:@"ball-1.png"];
    _ball.position = ccp(ball_x,ball_y);
    _ball.tag = 1;
    [self addChild:_ball];
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(ball_x/PTM_RATIO, ball_y/PTM_RATIO);
    ballBodyDef.userData = _ball;
    _ballBody = _world->CreateBody(&ballBodyDef);
    
    
    //ball shape
    b2CircleShape circle;
    circle.m_radius = (18.0/PTM_RATIO)/CC_CONTENT_SCALE_FACTOR();
    
    //ball fixture
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 2.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.15f;
    _ballFixture = _ballBody->CreateFixture(&ballShapeDef);
}

//puts hole on screen
- (void)spawnHole {
    _spawnPoint = [_objectGroup objectNamed:@"goal"];
    int hole_x = [_spawnPoint [@"x"]integerValue]/CC_CONTENT_SCALE_FACTOR();
    int hole_y = [_spawnPoint [@"y"] integerValue]/CC_CONTENT_SCALE_FACTOR();
    NSLog(@"%d + %d", hole_x, hole_y);
    _hole = [CCSprite spriteWithFile:@"hole.png"];
    _hole.position = ccp(hole_x,hole_y);
    [self addChild:_hole];
}


//puts bear on screen
- (void)spawnBear {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear.plist"];
    _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bear.png"];
    [self addChild:_spriteSheet];
    
    NSMutableArray *bearAnimFrames = [NSMutableArray array];
    for (int i=4; i<=7; i++) {
        [bearAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"bear%d.png",i]]];
    }
    
    CCAnimation *bearAnim = [CCAnimation
                             animationWithSpriteFrames:bearAnimFrames delay:0.25f];
    
    
    for(_spawnPoint in [_objectGroup objects]){
        if([[_spawnPoint valueForKey:@"bearSpawn"] intValue] == 1){
            mons_x = [[_spawnPoint valueForKey:@"x"] intValue]/CC_CONTENT_SCALE_FACTOR();
            mons_y = [[_spawnPoint valueForKey:@"y"] intValue]/CC_CONTENT_SCALE_FACTOR();
            _bear = [CCSprite spriteWithSpriteFrameName:@"bear4.png"];
            _bear.flipX = YES;
            _bear.tag = 2;
            _bear.position = ccp(mons_x, mons_y);
            _bearAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:bearAnim]];
            [_bear runAction:_bearAction];
            [self addBoxBodyForSprite:_bear];
            [_spriteSheet addChild:_bear];
            
            [_monsters addObject:_bear];
        }
    }
    CCFlipX *flipOnX = [CCFlipX actionWithFlipX:YES];
    CCFlipX *flipOffX = [CCFlipX actionWithFlipX:NO];
    
    
    [_bear runAction:[CCRepeatForever actionWithAction:
                    [CCSequence actions:
                     [CCMoveBy actionWithDuration:1.0 position:ccp(200,0)],
                     flipOffX,
                     [CCMoveBy actionWithDuration:1.0 position:ccp(-200,50)],
                     [CCMoveBy actionWithDuration:1.0 position:ccp(-100,-50)],
                     flipOnX,
                     [CCMoveBy actionWithDuration:1.0 position:ccp(100,0)],
                     nil]]];
}


//puts snakes on screen
- (void)spawnSnake {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"snakes.plist"];
    _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"snakes.png"];
    [self addChild:_spriteSheet];

    NSMutableArray *snakeAnimFrames = [NSMutableArray array];
    for (int i=1; i<=2; i++) {
        [snakeAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"snake%d.png",i]]];
    }

    CCAnimation *snakeAnim = [CCAnimation
                             animationWithSpriteFrames:snakeAnimFrames delay:0.25f];

    
    for(_spawnPoint in [_objectGroup objects]){
        if([[_spawnPoint valueForKey:@"SnakeSpawn"] intValue] == 1){
            mons_x = [[_spawnPoint valueForKey:@"x"] intValue]/CC_CONTENT_SCALE_FACTOR();
            mons_y = [[_spawnPoint valueForKey:@"y"] intValue]/CC_CONTENT_SCALE_FACTOR();
            _snake = [CCSprite spriteWithSpriteFrameName:@"snake1.png"];
            _snake.tag = 3;
            _snake.position = ccp(mons_x, mons_y);
            _snakeAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:snakeAnim]];

            CCFlipX *flipOnX = [CCFlipX actionWithFlipX:YES];
            CCFlipX *flipOffX = [CCFlipX actionWithFlipX:NO];
            
            
            //random delays
            float actualDelay = CCRANDOM_0_1() * 2.0f;
            
            id delay = [CCDelayTime actionWithDuration:actualDelay];
            NSLog(@"%f", actualDelay);
            
            //random movements
            int minX = 0;
            int maxX = 100;
            int rangeX = maxX - minX;
            
            int minY = 0;
            int maxY = 200;
            int rangeY = maxY - minY;
            
            int minY2 = 0;
            int maxY2 = 50;
            int rangeY2 = maxY2 - minY2;
            
            int actualX = arc4random() % rangeX;
            int actualY = arc4random() % rangeY;
            
            int actualY2 = arc4random() % rangeY2;
            int actualY3 = arc4random() % rangeY2;
            
            
            [_snake runAction:_snakeAction];
            [self addBoxBodyForSprite:_snake];
            [_spriteSheet addChild:_snake];
            [_snake runAction:[CCRepeatForever actionWithAction:
                               [CCSequence actions:
                                [CCMoveBy actionWithDuration:1.0 position:ccp(200+actualX,actualY2)],
                                delay, flipOnX, 
                                [CCMoveBy actionWithDuration:1.0 position:ccp(-(200+actualX),50+actualY)],
                                delay,
                                [CCMoveBy actionWithDuration:1.0 position:ccp(-(100+actualX),-(50+actualY))], delay, flipOffX, 
                                [CCMoveBy actionWithDuration:1.0 position:ccp((100+actualX)/2,-actualY3)],
                                delay,
                                [CCMoveBy actionWithDuration:1.0 position:ccp((100+actualX)/2,(actualY3-actualY2))], delay,
                                nil]]];
                            
            
            [_monsters addObject:_snake];
        }
    }
}


//puts crocodile on screen
- (void)spawnCroc {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"crocs.plist"];
    _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"crocs.png"];
    [self addChild:_spriteSheet];
    
    NSMutableArray *crocAnimFrames = [NSMutableArray array];
    for (int i=1; i<=2; i++) {
        [crocAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"croc%d.png",i]]];
    }
    
    CCAnimation *crocAnim = [CCAnimation
                             animationWithSpriteFrames:crocAnimFrames delay:1.0f];

    for(_spawnPoint in [_objectGroup objects]){
        if([[_spawnPoint valueForKey:@"crocSpawn"] intValue] == 1){
            mons_x = [[_spawnPoint valueForKey:@"x"] intValue]/CC_CONTENT_SCALE_FACTOR();
            mons_y = [[_spawnPoint valueForKey:@"y"] intValue]/CC_CONTENT_SCALE_FACTOR();
            _croc = [CCSprite spriteWithSpriteFrameName:@"croc1.png"];
            _croc.tag = 4;
            _croc.position = ccp(mons_x, mons_y);
            
            _crocAction = [CCRepeatForever actionWithAction:
                            [CCAnimate actionWithAnimation:crocAnim]];
            
            [_croc runAction:_crocAction];
            [self addBoxBodyForSprite:_croc];
            [_spriteSheet addChild:_croc];
            
            [_monsters addObject:_croc];
        }
        
    }
    
    
}

//-(void) keepMovingPersonRandomly
//{
//    float minX = person.boundingBox.size.width/2;
//    float maxX = self.contentSize.width-minX;
//    float minY = person.boundingBox.size.height/2;
//    float maxY = self.contentSize.height-minY;
//    CGPoint target = ccp(randFloat(minX, maxX), randFloat(minY, maxY));
//    ccTime moveDuration = ccpDistance(person.position, target) / personSpeed;
//    CCSequence *seq = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:target],
//                       [CCCallFuncN actionWithTarget:self selector:@selector(keepMovingPersonRandomly)],
//                       nil];
//    [person runAction:seq];
//}



//add precise collision box for the monster sprites
- (void)addBoxBodyForSprite:(CCSprite *)sprite {
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                               sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    
    _spriteBody = _world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
//    spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
//                         sprite.contentSize.height/PTM_RATIO/2);
    if (sprite.tag == 2) { //bear
        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2((-6.6f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-67.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((66.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-40.1f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((28.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (36.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((3.6f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (65.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-19.4f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (54.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-63.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (9.5f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-17.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-43.4f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO)
        };

        // Then add this
        spriteShape.Set(verts, num);
    } else if (sprite.tag == 3) { //snake
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2((-18.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-63.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((44.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-48.1f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((62.5f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (24.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((29.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (66.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-23.6f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (66.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-48.0f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (29.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-62.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-42.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-43.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-61.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO)
        };
        // Then add this
        spriteShape.Set(verts, num);
    }else if (sprite.tag == 4) { //croc
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2((-144.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (9.3f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-103.4f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-64.7f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((3.1f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-92.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((121.4f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (-51.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((142.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (7.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((82.1f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (72.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((2.4f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (90.2f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO),
            b2Vec2((-82.8f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO, (72.9f/CC_CONTENT_SCALE_FACTOR()) / PTM_RATIO)
        };

        // Then add this
        spriteShape.Set(verts, num);
    }

    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
    _spriteBody->CreateFixture(&spriteShapeDef);
    
}



//DRAWS the bounding boxes for wall collision
- (void) makeBox2dObjAt:(CGPoint)p
			   withSize:(CGPoint)size
				dynamic:(BOOL)d
			   rotation:(long)r
			   friction:(long)f
				density:(long)dens
			restitution:(long)rest
				  boxId:(int)boxId {
    
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
    //	bodyDef.angle = r;
    
	if(d)
		bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    
    GameObject *platform = [[GameObject alloc] init];
    [platform setType:kGameObjectPlatform];
	bodyDef.userData = platform;
    
    _wallBody = _world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(size.x/2/PTM_RATIO, size.y/2/PTM_RATIO);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = dens;
	fixtureDef.friction = f;
	fixtureDef.restitution = rest;
	_wallFixture = _wallBody->CreateFixture(&fixtureDef);
}


//SPECIFY WHERE the wall is for collision
- (void) drawCollisionTiles {
	CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"wall_collide"];
	NSMutableDictionary * objPoint;
    
	int x, y, w, h;
	for (objPoint in [objects objects]) {
		x = [[objPoint valueForKey:@"x"] intValue]/CC_CONTENT_SCALE_FACTOR();
		y = [[objPoint valueForKey:@"y"] intValue]/CC_CONTENT_SCALE_FACTOR();
		w = [[objPoint valueForKey:@"width"] intValue]/CC_CONTENT_SCALE_FACTOR();
		h = [[objPoint valueForKey:@"height"] intValue]/CC_CONTENT_SCALE_FACTOR();
        
		CGPoint _point=ccp(x+w/2,y+h/2);
		CGPoint _size=ccp(w,h);
        
		[self makeBox2dObjAt:_point
					withSize:_size
					 dynamic:false
					rotation:0
					friction:1.5f
					 density:0.0f
				 restitution:0
					   boxId:-1];
	}
    
}



//sets camera on ball
-(void)setViewPointCenter:(CGPoint)position{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int x = MAX(position.x, winSize.width/2);
    int y = MAX(position.y, winSize.height/2);
    x = MIN(x,(_tileMap.mapSize.width * (_tileMap.tileSize.width/CC_CONTENT_SCALE_FACTOR())) - winSize.width/2);
    y = MIN(y, (_tileMap.mapSize.height * (_tileMap.tileSize.height/CC_CONTENT_SCALE_FACTOR())) - winSize.height/2);
    CGPoint actualPosition = ccp(x,y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}


//simulates accelerometer on simulator, accurate only on iPhone simulator
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    [self updateBallForce:touch];

    
}


- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    [self updateBallForce:touch];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    b2Vec2 force (0,0);
    _ballForce = force;
    NSLog(@"Force: %f, %f", _ballForce.x, _ballForce.y);
}

- (void) updateBallForce: (UITouch *) touch {
    
    // Get the location of the touch
    CGPoint location = [touch locationInView:touch.view];
    
    // Find the position relative to the centre of the screen
    // remember the screen is 480x320 with the origin at the
    // top left hand corner
    float xRel = location.x - 240;
    // Make it so y-up is positive negative
    float yRel = -location.y + 160;
    
    // Scale xRel and yRel so they vary between 0 and 1
    xRel = xRel / 240;
    yRel = yRel / 160;
    
    
    // Now apply a force to the ball
    float maxForce = 15 ;
    
    // Check that there is a ball
    if(_ball != Nil) {
        //b2Body * ballBody;
        
        // Set the linear damping. This means that if the ball
        // will gradually come to rest if we don't tilt the
        // phone.
        _ballBody->SetLinearDamping(0.5);
        
        // Make sure the body is awake
        _ballBody->SetAwake(YES);
        
        // Create a new force depending on where we've touched on the screen
        b2Vec2 force (xRel * maxForce * _ballBody->GetMass(), yRel * maxForce* _ballBody->GetMass());
        _ballForce = force;
    
    }

}
//end of accelerometer simulator



//accelerometer sensitivty
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    b2Vec2 gravity(acceleration.y * 30, -acceleration.x * 30);
    _world->SetGravity(gravity);
}


-(void) actions_pause{
//    [_bear pauseSchedulerAndActions];
//    [_snake pauseSchedulerAndActions];
//    [_croc pauseSchedulerAndActions];
    
    
    for (CCSprite *monster in _monsters) {
        [monster pauseSchedulerAndActions];
    }

}

-(void) actions_resume{
//    [_bear resumeSchedulerAndActions];
//    [_snake resumeSchedulerAndActions];
//    [_croc resumeSchedulerAndActions];
    
    for (CCSprite *monster in _monsters) {
        [monster resumeSchedulerAndActions];
    }
}



//updates every dt time
-(void)tick:(ccTime)dt{
    //NSLog(@"Is it: %@", hud_paused? @"Yes":@"No");
    hud_paused = _hud.paused;
    
    //if game is NOT paused
    if(!hud_paused){
        [self actions_resume];
        
    // Apply a force to the ball
    if(_ball != Nil) {
        if(_ballForce.x!=0 && _ballForce.y != 0) {
            _ballBody->ApplyForce(_ballForce, _ballBody->GetWorldCenter());
        }
    }
        
        
    // hud layer ontop of game layer
    [_hud setStatusString:[NSString stringWithFormat:@"Score: %d", 0]];
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()){
        if(b->GetUserData() != NULL){
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            if (sprite.tag == 1) {
                sprite.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
            if (sprite.tag == 2) {
                b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                           sprite.position.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                
                b->SetTransform(b2Position, b2Angle);
            }
            if (sprite.tag == 3) {
                b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                           sprite.position.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                
                b->SetTransform(b2Position, b2Angle);
            }
            if (sprite.tag == 4) {
                b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                           sprite.position.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
                
                b->SetTransform(b2Position, b2Angle);
            }
            
        }
    }

        if (CGRectIntersectsRect(_ball.boundingBox, _hole.boundingBox)) {
            holePos = _hole.position;
            ballPos = _ball.position;
            holeSize = _hole.boundingBox.size;
            
            // Calculate the distance of ball from the hole
            float dist = sqrtf(powf(holePos.x - ballPos.x, 2) + powf(holePos.y - ballPos.y, 2));
            
            
            
            // If the distance is less than 50% of the balls width it will fall
            // This is because in reality the contact surface of the ball on the
            // wood is very small and occurs at 50% of the balls width. Only when
            // this contact area is in the hole will the ball fall.
            if(dist < 0.4 * _ball.boundingBox.size.width) {
                [self triggerFallAnimation];
            }
        }

    //check for collision between ball body and other bodies
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            if ((spriteA.tag == 1 && spriteB.tag == 2) || (spriteA.tag == 1 && spriteB.tag == 3) || (spriteA.tag == 1 && spriteB.tag == 4)) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"death1.wav"];
                _ballBody->SetAwake(false);
              
//                [_hud showRestartMenu:NO];
//                [self unscheduleAllSelectors];
              
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];


            } else if ((spriteA.tag == 2 && spriteB.tag == 1) || (spriteA.tag == 3 && spriteB.tag == 1) || (spriteA.tag == 4 && spriteB.tag == 1)) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"death1.wav"];
                _ballBody->SetAwake(false);
                

//                [_hud showRestartMenu:NO];
//                [self unscheduleAllSelectors];
                             
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
    }
    
    [self setViewPointCenter:_ball.position];
}
    
    //if game IS paused
    else{
        //[[CCDirector sharedDirector]pause];
        [self actions_pause];
//        [_bear pauseSchedulerAndActions];
    }
    
}


//ball animation upon reaching hole
-(void) triggerFallAnimation {
    _ballBody->SetAwake(false);
    [self unscheduleAllSelectors];
    // Get the position of the hole
    holePos = _hole.position;
    // Get the hole size
    holeSize = _hole.boundingBox.size;
    
    // Move the ball to the centre of the hole
    b2Vec2 b2Position = b2Vec2((holePos.x + 1)/PTM_RATIO, (holePos.y+ 1)/PTM_RATIO);
    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(_ball.rotation);
    _ballBody->SetTransform(b2Position, b2Angle);
   
   //    id move = [CCMoveTo actionWithDuration:0.1  position:ccp(100,100)];
    
    id move = [CCMoveTo actionWithDuration:0.1  position:ccp(holePos.x + holeSize.width*0.1,
                                                             holePos.y + holeSize.height*0.1)];

    // Shrink the ball to 50% of it's normal size
    id shrink = [CCScaleTo actionWithDuration:0.5 scale:0];
    
    // Setup the frame by frame rolling animation
    
   
//    id animate = [CCAnimate actionWithAnimation:_ballAnimationFrames];
    
//    id animate = [CCAnimate  actionWithAnimation:[CCAnimation animationWithSpriteFrames:_ballAnimationFrames delay:0.1]];
    
    // When the animation has ended call the endAnimation function
    id end = [CCCallFunc actionWithTarget:self selector:@selector(endAnimation)];

   
    // Put these actions into a sequence and run them when ball is "falling"
    [_ball runAction:[CCSequence actions: move, shrink, end, nil]];
    

//    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()) {
//        CCSprite *sprite = (CCSprite *) b->GetUserData();
//        if(sprite.tag == 1)
//            _world->DestroyBody(b);
//    }

}


-(void) endAnimation {
    [[SimpleAudioEngine sharedEngine] playEffect:@"win2.wav"];
//    [_hud showRestartMenu:YES];
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}


-(void)dealloc{
    delete _world;
    _ballBody = NULL;
    _world = NULL;
    delete _contactListener;
    [super dealloc];
}

@end