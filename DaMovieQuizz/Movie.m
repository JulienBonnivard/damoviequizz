#import "Movie.h"

@implementation Movie

@synthesize  idMovie= _idMovie,urlImage =_urlImage,idActors=_idActors;

- (id) init:(NSString *)idMovie url:(NSString *)urlImage {
    self = [super init];
    
    self.idMovie = idMovie;
    self.urlImage = urlImage;
    return self;
}

- (id) init:(NSString *)idMovie url:(NSString *)urlImage idActors:(NSMutableDictionary*)idActors{
    self = [super init];
    
    self.idMovie = idMovie;
    self.urlImage = urlImage;
    self.idActors=idActors;
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_idMovie forKey:@"idMovie"];
    [encoder encodeObject:_urlImage forKey:@"urlImage"];
    [encoder encodeObject:_idActors forKey:@"idActors"];
}
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        // If parent class also adopts NSCoding, replace [super init]
        // with [super initWithCoder:decoder] to properly initialize.
        
        self.idMovie = [decoder decodeObjectForKey:@"idMovie"];
        self.urlImage = [decoder decodeObjectForKey:@"urlImage"];
        self.idActors = [decoder decodeObjectForKey:@"idActors"];
        
    }
    return self;
}

@end
