#import <Foundation/Foundation.h>

@interface Actor : NSObject <NSCoding>

@property(nonatomic,strong) NSString	*idActor;
@property(nonatomic,strong) NSString	*urlImage;

- (id) init:(NSString *)idActor url:(NSString *)urlImage;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

//save
@property (nonatomic,strong) NSMutableDictionary *actorList;
@property (nonatomic,strong) NSMutableDictionary *movieList;

- (NSString *) actorFile;
- (NSString *) movieFile;

- (NSMutableDictionary *)loadMovie;
- (NSMutableDictionary *)loadActor;

- (BOOL)archivingActor:(NSMutableDictionary *) actorDict;
- (BOOL)archivingMovie:(NSMutableDictionary *) movieDict;
+ (Actor*)sharedInstance;


@end
