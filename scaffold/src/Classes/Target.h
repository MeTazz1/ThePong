//
//  Target.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "SPImage.h"
#import "PlayerMouvement.h"

@interface Target : SPImage
{
}

@property (nonatomic) float speed;
@property (nonatomic, retain) SPPoint *initialePosition;
@property (nonatomic) BOOL hasBeenKicked;

- (Target*)initWithContentsOfFile:(NSString*)file;

@end
