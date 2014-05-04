//
//  World.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "World.h"

@implementation World


- (World*)initWorld
{
    if (self = [super init])
    {
        wBackground = [[SPImage alloc] initWithContentsOfFile:@"table.png"];
        wBackground.width = GAME_WIDTH;
        wBackground.height = GAME_HEIGHT;
        [wBackground setHeight:[UIApplication sharedApplication].keyWindow.frame.size.height];
        [self addChild:wBackground];
    }
    return self;
}


- (void)dealloc
{
    [self removeChild:wBackground];
    
    [wBackground release];
    [super dealloc];
}

@end
