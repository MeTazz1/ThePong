//
//  Target.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "Target.h"

@implementation Target

@synthesize speed = _speed;
@synthesize initialePosition = _initialePosition;
@synthesize hasBeenKicked = _hasBeenKicked;

- (Target*)initWithContentsOfFile:(NSString*)file
{
    if (self = [super initWithContentsOfFile:file])
    {
        _speed = 50.0f;
        _initialePosition = [[SPPoint alloc] initWithX:0.0f y:0.0f];
        _hasBeenKicked = NO;
    }
    return self;
}


@end
