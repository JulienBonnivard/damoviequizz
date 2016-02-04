
@interface UserConfig : NSObject

@property (nonatomic,strong) NSMutableDictionary *actorNotInMovieList;
@property (nonatomic,strong) NSMutableDictionary *actorInMovieList;
@property (nonatomic,strong) NSMutableDictionary *movieList;
@property (nonatomic,strong) NSMutableDictionary *gamerList;

@property(nonatomic,strong)  NSString	*bestScore;

- (NSString *) actorNotInMovieFile;
- (NSString *) actorInMovieFile;
- (NSString *) movieFile;
- (NSString *) gamerFile;

- (NSMutableDictionary *)loadGamer;

- (NSMutableDictionary *)loadMovie;
- (NSMutableDictionary *)loadActorNotInMovie;
- (NSMutableDictionary *)loadActorInMovie;
- (BOOL)archivingGamer:(NSMutableDictionary *) gamerDict;


- (BOOL)archivingActorNotInMovie:(NSMutableDictionary *) actorDict;
- (BOOL)archivingActorInMovie:(NSMutableDictionary *) actorDict ;

- (BOOL)archivingMovie:(NSMutableDictionary *) movieDict;

+ (UserConfig*)sharedInstance;

- (void)Save;
- (BOOL)Load;
- (void)Init;
@end