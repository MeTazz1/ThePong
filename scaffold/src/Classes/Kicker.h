//
//  Kicker.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "SPSprite.h"
#import "PlayerMouvement.h"
#import "RacketSide.h"

@interface Kicker : SPImage

@property (nonatomic, assign) PlayerMovementType movementType;
@property (nonatomic, assign) RacketSide side;
@property (nonatomic) float speed;

- (Kicker*)initWithContentsOfFile:(NSString*)file;

@end
