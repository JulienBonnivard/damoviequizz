#import "Gamer.h"

@implementation Gamer

@synthesize  score=_score,name=_name,time=_time,idGamer=_idGamer;

- (id) init:(NSString*)idGamer score:(NSString*)score name:(NSString *)name time:(NSString *)time {
    self = [super init];
    self.idGamer=idGamer;
    self.score = [score integerValue];
    self.name = name;
    self.time= time;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:_idGamer forKey:@"idGamer"];
    [encoder encodeObject:[NSString stringWithFormat:@"%i", _score] forKey:@"score"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_time forKey:@"time"];
}
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        self.idGamer= [decoder decodeObjectForKey:@"idGamer"];
        self.score =[[decoder decodeObjectForKey:@"score"] integerValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.time = [decoder decodeObjectForKey:@"time"];
    }
    return self;
}

- (NSComparisonResult)compare:(Gamer *)otherGamer
{
    NSInteger mygamescore = [self score];
    NSInteger othergamescore = [otherGamer score];
    if (mygamescore < othergamescore)
        return NSOrderedAscending;
    if (mygamescore > othergamescore)
        return NSOrderedDescending;
    return NSOrderedSame;
}

@end
