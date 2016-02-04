
@interface Movie : NSObject <NSCoding>

@property(nonatomic,strong) NSString	*idMovie;
@property(nonatomic,strong) NSString	*urlImage;
@property(nonatomic,strong) NSMutableDictionary	*idActors;


- (id) init:(NSString *)idMovie url:(NSString *)urlImage;
- (id) init:(NSString *)idMovie url:(NSString *)urlImage idActors:(NSMutableDictionary*)idActors;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
