
@interface Gamer : NSObject <NSCoding>

@property NSInteger   score;
@property(nonatomic,strong) NSString	*name;
@property(nonatomic,strong) NSString	*time;
@property(nonatomic,strong) NSString	*idGamer;

- (id) init:(NSString*)idGamer score:(NSString*)score name:(NSString *)name time:(NSString *)time ;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

- (NSComparisonResult)compare:(Gamer *)otherGamer;

@end
