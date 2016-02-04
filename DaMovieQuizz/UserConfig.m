//#import "UserConfig.h"
//#import "JSON.h"

NSString *const ACTOR_NOT_IN_MOVIE_STORE = @"actorNotInMovie";
NSString *const ACTOR_IN_MOVIE_STORE = @"actorInMovie";
NSString *const GAMER_STORE = @"gamer";
NSString *const MOVIE_STORE = @"movie";
NSString *const CONFIG_STORE = @"config1.0.0.data";


@implementation UserConfig
@synthesize movieList,actorInMovieList,actorNotInMovieList,bestScore=_bestScore;

-(void)Init{
    [self setBestScore:@"0"];
}
- (BOOL)Load {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [NSString	stringWithFormat:@"%@/%@", documentsDirectory,CONFIG_STORE];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    
    if (dict != nil)
    {
        [self setBestScore:[dict objectForKey:@"bestScore"]];
        
        return TRUE;
    } else{
        [self Init];
        [self Save];
        return FALSE;
    }
}

- (void)Save {
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              _bestScore,@"bestScore",
                              nil];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *file = [NSString	stringWithFormat:@"%@/%@", documentsDirectory,CONFIG_STORE];
        
        [dict writeToFile:file atomically:YES];
        
    } @catch (NSException *e) {
        
    }
}

- (NSString *) gamerFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.data", documentsDirectory,GAMER_STORE];
}
- (NSString *) actorNotInMovieFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.data", documentsDirectory,ACTOR_NOT_IN_MOVIE_STORE];
}
- (NSString *) actorInMovieFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.data", documentsDirectory,ACTOR_IN_MOVIE_STORE];
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
- (NSMutableDictionary *)loadGamer {
    NSMutableDictionary *dict = nil;
    NSLog(@"%@",[self gamerFile]);
    NSData * data = [NSData dataWithContentsOfFile:[self gamerFile]];
    if(data != nil)
    {
        dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.gamerList = dict;
    }
    return self.gamerList;
}
- (NSMutableDictionary *)loadActorNotInMovie {
    NSMutableDictionary *dict = nil;
    NSLog(@"%@",[self actorNotInMovieFile]);
    NSData * data = [NSData dataWithContentsOfFile:[self actorNotInMovieFile]];
    if(data != nil)
    {
        dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.actorNotInMovieList = dict;
    }
    return self.actorNotInMovieList;
}

- (NSMutableDictionary *)loadActorInMovie {
    NSMutableDictionary *dict = nil;
    NSLog(@"%@",[self actorInMovieFile]);
    NSData * data = [NSData dataWithContentsOfFile:[self actorInMovieFile]];
    if(data != nil)
    {
        dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.actorInMovieList = dict;
    }
    return self.actorInMovieList;
}
- (BOOL)archivingGamer:(NSMutableDictionary *)gamerDict {
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[gamerDict mutableCopy]];
    if ([data writeToFile:[self gamerFile] atomically:YES])
        return true;
    else
        return false;
}
- (BOOL)archivingActorNotInMovie:(NSMutableDictionary *) actorDict {
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[actorDict mutableCopy]];
    if ([data writeToFile:[self actorNotInMovieFile] atomically:YES])
        return true;
    else
        return false;
}

- (BOOL)archivingActorInMovie:(NSMutableDictionary *) actorDict {
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[actorDict mutableCopy]];
    if ([data writeToFile:[self actorInMovieFile] atomically:YES])
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
+ (UserConfig*)sharedInstance
{
    static UserConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserConfig alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end