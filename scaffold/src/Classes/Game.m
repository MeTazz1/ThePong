//
//  Game.m
//  AppScaffold
//

#import "Game.h"
#import "Bonus.h"

#pragma mark - Private 

@interface Game ()

- (void)setup;
- (void)setupTarget;
- (void)setupControls;
- (void)setupKicker;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Game
    
- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    // release any resources here
    [Media releaseAtlas];
    [Media releaseSound];
    
    //event listeners must be removed in the dealloc phase
	[self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    
	[_racket release];
    [_target release];
	[super dealloc];
}

#pragma mark - Setups

- (void)setupTarget
{
    _target = [[Target alloc] initWithContentsOfFile:@"ball.png"];
    _target.width = _target.width / 3;
    _target.height = _target.height / 3;
    _target.y = -80;
    _target.x = GAME_WIDTH / 2;
    [self addChild:_target];
    
    SPTween *animFirst = [SPTween tweenWithTarget:_target time:1.0f transition:SP_TRANSITION_LINEAR];
    [animFirst moveToX:_target.x y:NET_POSITION_Y];
    [animFirst scaleTo:0.7];
    animFirst.onComplete = ^{
            [Sparrow.juggler removeObject:animFirst];
            _ballAnimation = [SPTween tweenWithTarget:_target time:1.0f transition:SP_TRANSITION_LINEAR];
            [_ballAnimation moveToX:_target.x y:GAME_HEIGHT];
            [_ballAnimation scaleTo:0.5];
            _ballAnimation.onComplete = ^{
                [Sparrow.juggler removeObject:_ballAnimation];
            };
            [Sparrow.juggler addObject:_ballAnimation];
    };
    [Sparrow.juggler addObject:animFirst];
}

- (void)setupKicker
{
    _racket = [[Kicker alloc] initWithContentsOfFile:@"racket.png"];
    _racket.x = GAME_WIDTH / 2;
    _racket.y = GAME_HEIGHT - 50;
    _racket.width = _racket.width / 2;
    [self addChild:_racket];
    [_racket addEventListener:@selector(onRacketTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)setupControls
{
    _movementControls = [MovementControls new];
    _movementControls.y = GAME_HEIGHT - (GAME_HEIGHT / 3);
    _movementControls.x = -(GAME_WIDTH / 3) - 10;
    [self addChild:_movementControls];
    [self addEventListener:@selector(onMovementChanged:) atObject:self forType:EVENT_TYPE_MOVEMENT_CHANGED];
}

- (void)setup
{
    [SPAudioEngine start];
    
    [Media initAtlas];
    [Media initSound];
    
    [self initWorld];
    [self setupKicker];
    [self setupTarget];
    
    saveMove = 0;
    moveList = [NSMutableArray new];
//    [self setupControls];

    _totalTime = 0.0f;
    _distance = 0.0f;

    [self addEventListener:@selector(onFallingTarget:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

#pragma mark - Frames

- (void)onFallingTarget:(SPEnterFrameEvent *)event
{
	float passedTime = (float)event.passedTime;
    _totalTime += passedTime;
    

    SPRectangle *racketBounds = _racket.bounds;
    racketBounds.width += 40;
    SPRectangle *ballBounds = _target.bounds;
    SPRectangle *collision = [racketBounds intersectionWithRectangle:ballBounds];
    
    if (_target.y <= -85)
    {
        _target.hasBeenKicked = NO;
        [Sparrow.juggler removeObject:_ballAnimation];
        _target.initialePosition.x = _target.x;
        _target.initialePosition.y = _target.y;
        
        int finalX = (20 + (arc4random() % (int)GAME_WIDTH - 20));
        
        _ballAnimation = [SPTween tweenWithTarget:_target time:1.0f transition:SP_TRANSITION_LINEAR];
        [_ballAnimation moveToX:((_target.x + finalX) / 2) y:NET_POSITION_Y];
        [_ballAnimation scaleTo:0.7];
        _ballAnimation.onComplete = ^{
            [Sparrow.juggler removeObject:_ballAnimation];
            _ballAnimation = [SPTween tweenWithTarget:_target time:1.0f transition:SP_TRANSITION_LINEAR];
            [_ballAnimation moveToX:finalX y:GAME_HEIGHT];
            [_ballAnimation scaleTo:0.4];
            _ballAnimation.onComplete = ^{
                [Sparrow.juggler removeObject:_ballAnimation];
            };
            [Sparrow.juggler addObject:_ballAnimation];
        };
        [Sparrow.juggler addObject:_ballAnimation];
        _totalTime = 0.0f;
    }
    
    if (collision.x != 0 && collision.y != 0 && _target.hasBeenKicked == NO)
    {
        
        [Sparrow.juggler removeObject:_ballAnimation];
        _target.hasBeenKicked = YES;
        
        // Handle collision depending on last moves
        SPPoint *finalDirection = [self getFinalDirection:collision];
        
        float totalTime = 100 / _target.speed;
        _ballAnimation = [SPTween tweenWithTarget:_target time:totalTime transition:SP_TRANSITION_LINEAR    ];
        [_ballAnimation moveToX:finalDirection.x y:-90];
        [_ballAnimation scaleTo:0.4];
        _ballAnimation.onComplete = ^{
            [Sparrow.juggler removeObject:_ballAnimation];
        };
        [Sparrow.juggler addObject:_ballAnimation];
        _totalTime = 0.0f;
    }
}

- (void)onRacketTouch:(SPTouchEvent *)event
{

	SPTouch *touch = [[event.touches allObjects] objectAtIndex:0];
	SPPoint *localTouchPosition = [touch locationInSpace:self];
    localTouchPosition.x -= 40;
    localTouchPosition.y -= 40;
    
    ++saveMove;
    if (saveMove % 20 == 0)
        [moveList addObject:localTouchPosition];
    
    if (localTouchPosition.y >= (GAME_HEIGHT / 2) && localTouchPosition.y < (GAME_HEIGHT - _racket.height))
        _racket.y = localTouchPosition.y;
    else
    {
        if (localTouchPosition.y < (GAME_HEIGHT / 2))
            _racket.y = (GAME_HEIGHT / 2);
        else if (localTouchPosition.y < (GAME_HEIGHT - _racket.height))
            _racket.y = GAME_HEIGHT - _racket.height;
    }
    if (localTouchPosition.x <= (GAME_WIDTH - _racket.width / 1.5))
    {
        _racket.x = localTouchPosition.x;
    }
}

- (SPPoint*)getFinalDirection:(SPRectangle*)collisionPoint
{
    SPPoint *lastKnownRacketPoint = [moveList lastObject];
    SPPoint *finalPoint = [SPPoint new];

    float xMalus = _racket.x - lastKnownRacketPoint.x;
    float yMalus = _racket.y - lastKnownRacketPoint.y;
    
    // Direction
    if (_target.x + (xMalus * 2) < 30 || _target.x + (xMalus * 2) > (GAME_WIDTH - 30))
        (_target.x + (xMalus * 2) < 30) ? (finalPoint.x = 30) : (finalPoint.x = (GAME_WIDTH - 30));
    else
        finalPoint.x = _target.x + (xMalus * 2);

    // Speed
    _target.speed = (_target.speed * 0.5) - yMalus;

    // Ball d'effet
    
    return finalPoint;
}

@end
