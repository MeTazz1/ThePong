//
//  Bonus.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/28/13.
//
//

#import "Bonus.h"

@implementation Bonus

+ (NSString*)getBonusTexture:(BonusType)type
{
    NSDictionary *textureDictionary = @{[NSNumber numberWithInt:BONUS_SPEEDUP]: @"ryu.xml",
                                        [NSNumber numberWithInt:BONUS_NITRO]: @"ryu.xml"
                                        };
    return [textureDictionary objectForKey:[NSNumber numberWithInt:type]];
}

- (Bonus*)initWithBonusType:(BonusType)type andId:(NSString*)id
{
    SPTextureAtlas *bonusTexture = [SPTextureAtlas atlasWithContentsOfFile:[Bonus getBonusTexture:type]];
    NSArray *frames = [bonusTexture texturesStartingWith:@"walk_"];
    if (self = [super initWithFrames:frames fps:20])
    {
        _id = id;
        _type = type;
        self.width = 30;
        self.height = 30;
    }
    return self;
}

@end
