#import <Foundation/Foundation.h>

@interface Actor : NSObject <NSCoding>

@property(nonatomic,strong) NSString	*idActor;
@property(nonatomic,strong) NSString	*urlImage;

- (id) init:(NSString *)idActor url:(NSString *)urlImage;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
