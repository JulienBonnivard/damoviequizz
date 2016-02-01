@interface DataSourceManager : NSObject

@property (weak, nonatomic) IBOutlet UIImageView *movieCoverImageView;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSMutableDictionary *actorInMovieDict;
@property (strong, nonatomic) NSMutableDictionary *actorNotInMovieDict;
@property (strong, nonatomic) NSArray *moviesArray;
@property (copy, nonatomic) NSString *randomStringId;
@property (copy, nonatomic) NSString *imagesBaseUrlString;
@property (strong, nonatomic) IBOutlet UIImageView *actorCoverImageView;
@property (copy, nonatomic) NSString *idMovie;
@property (copy, nonatomic) NSString *idActor;

-(void)saveActorInMovie : (NSString *)idMovieSend posterURL:(NSString*)posterURL;
-(void)saveActorNotInMovie;
-(void)saveMovie;
-(void)loadConfiguration;

+ (DataSourceManager*)sharedInstance;

@end
