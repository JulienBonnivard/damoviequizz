#import "Actor.h"

@implementation Actor

@synthesize  idActor= _idActor,urlImage =_urlImage;

- (id) init:(NSString *)idActor url:(NSString *)urlImage {
	self = [super init];
	
    self.idActor = idActor;
    self.urlImage = urlImage;
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_idActor forKey:@"idActor"];
    [encoder encodeObject:_urlImage forKey:@"urlImage"];
   
}
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        
        self.idActor = [decoder decodeObjectForKey:@"idActor"];
        self.urlImage = [decoder decodeObjectForKey:@"urlImage"];
    }
    return self;
}

@end
