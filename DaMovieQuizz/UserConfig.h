#import <UIKit/UIKit.h>
#import "Actor.h"
#import "Utility.h"

@class Actor;

@interface UserConfig : NSObject

@property (nonatomic,strong) NSMutableDictionary *actorList;
@property (nonatomic,strong) NSMutableDictionary *movieList;

- (NSString *) actorFile;
- (NSString *) movieFile;

- (NSMutableDictionary *)loadMovie;
- (NSMutableDictionary *)loadActor;

- (BOOL)archivingActor:(NSMutableDictionary *) actorDict;
- (BOOL)archivingMovie:(NSMutableDictionary *) movieDict;

@end