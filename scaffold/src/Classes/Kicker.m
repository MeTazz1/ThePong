//
//  Kicker.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "Kicker.h"

@implementation Kicker

- (Kicker*)initWithContentsOfFile:(NSString*)file
{
    if (self = [super initWithContentsOfFile:file])
    {
        _speed = 0.0f;
        [self addEventListener:@selector(update:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

- (void)update:(SPEnterFrameEvent *)event
{
    self.x += _movementType * 5.0f;
}

@end
