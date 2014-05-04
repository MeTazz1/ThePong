//
//  Bonus.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/28/13.
//
//

#import "SPSprite.h"

typedef enum BonusType {
    BONUS_SPEEDUP,
    BONUS_NITRO,
} BonusType;

@interface Bonus : SPMovieClip
{
    float _distance;

@public
    BonusType _type;
    NSString *_id;
}

- (Bonus*)initWithBonusType:(BonusType)type andId:(NSString*)id;

@end
