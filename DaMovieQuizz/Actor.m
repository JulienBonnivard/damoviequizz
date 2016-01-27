#import "Actor.h"
NSString *const ACTOR_STORE = @"actor";
NSString *const MOVIE_STORE = @"movie";

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
//save
- (NSString *) actorFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.data", documentsDirectory,ACTOR_STORE];
}

- (NSString *) movieFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.data", documentsDirectory,MOVIE_STORE];
}

- (NSMutableDictionary *)loadMovie {
    NSMutableDictionary *dict = nil;
    NSLog(@"%@",[self movieFile]);
    NSData * data = [NSData dataWithContentsOfFile:[self movieFile]];
    if(data != nil)
    {
        dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.movieList = dict;
    }
    return self.movieList;
}
- (NSMutableDictionary *)loadActor {
    NSMutableDictionary *dict = nil;
    NSLog(@"%@",[self actorFile]);
    NSData * data = [NSData dataWithContentsOfFile:[self actorFile]];
    if(data != nil)
    {
        dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.actorList = dict;
    }
    return self.actorList;
}

- (BOOL)archivingActor:(NSMutableDictionary *) actorDict {
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[actorDict mutableCopy]];
    if ([data writeToFile:[self actorFile] atomically:YES])
        return true;
    else
        return false;
}


- (BOOL)archivingMovie:(NSMutableDictionary *) movieDict {
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[movieDict mutableCopy]];
    if ([data writeToFile:[self movieFile] atomically:YES])
        return true;
    else
        return false;
}

@end
