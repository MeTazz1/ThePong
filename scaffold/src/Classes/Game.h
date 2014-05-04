//
//  Game.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import "Target.h"
#import "World.h"
#import "Kicker.h"
#import "MovementControls.h"

#define GRAVITY 16.0
#define EVENT_TYPE_MOVEMENT_CHANGED @"movement"

@interface Game : World
{
@private
    Kicker *_racket;
    Target *_target;
    SPTween *_ballAnimation;
    
    int saveMove;
    NSMutableArray *moveList;
    
    float _distance;
    // Total time handler
	float _totalTime;
    
    MovementControls *_movementControls;
}

@end
