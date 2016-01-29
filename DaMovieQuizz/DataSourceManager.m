#import "JLTMDbClient.h"
#import "DataSourceManager.h"
#import "Actor.h"
#import "Movie.h"

@implementation DataSourceManager

@synthesize actorInMovieDict,actorNotInMovieDict,moviesDict,idMovie,imagesBaseUrlString,arrayIdActors;

-(void)saveMovie{
    moviesDict =[[NSMutableDictionary alloc] init];
    int randomBool = arc4random() %(100)-1; //
    NSString* randomString = [NSString stringWithFormat:@"%d",randomBool];
    
    //__block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    
    //[moviesDict removeAllObjects];
    for (int i = 1; i <= 10; i++){
        
        int randomBool = arc4random() %(100)-1; //
        NSString* randomString = [NSString stringWithFormat:@"%d",randomBool];
        
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:@{@"page": randomString} andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                
                NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
                
                for (NSDictionary *movieDic in moviesResult){
                    NSString *posterURL = @"";
                    if ([movieDic objectForKey:@"poster_path"]!=nil){
                        posterURL = [movieDic objectForKey:@"poster_path"];
                        idMovie=[NSString stringWithFormat:@"%@", [movieDic objectForKey:@"id"]];
                        
                        // NSLog(@"URL : %@",posterURL);
                        // NSLog(@"ID MOVIE : %@",idMovies);
                        
                        Movie *newMovie = [[Movie alloc]init:idMovie url:posterURL];
                        
                        [moviesDict setObject:newMovie forKey:idMovie];
                        
                        [self saveActorInMovie:idMovie posterURL:posterURL];
                    }
                }
                [[[UserConfig sharedInstance] movieList]setDictionary:moviesDict];
                [[UserConfig sharedInstance] archivingMovie:moviesDict];
                //   NSLog(@"COUNT ARRAY MOVIES : %lu et RANDOM ID : %@", (unsigned long)[array count], randomStringId);
                //   NSLog(@"DICO MOVIE : %@", [[[UserConfig sharedInstance]movieList]description]);
                
            }else{
                // [errorAlertView show];
            }
        }];
    }
}

-(void)saveActorInMovie : (NSString *)idMovieSend posterURL:(NSString*)posterURL{
    
    actorInMovieDict = [[NSMutableDictionary alloc] init];
    arrayIdActors= [[NSMutableArray alloc]init];
    
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovieSend} andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableDictionary* moviesResult = [response objectForKey:@"cast"];
            for (NSDictionary *movieDic in moviesResult){
                NSString *idActorString = @"",*imageActor=@"";
                if ([movieDic objectForKey:@"name"]!=nil){
                    idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                    imageActor = [movieDic objectForKey:@"profile_path"];
                    
                    if (idActorString !=nil || ![idActorString isEqualToString: @""]|| imageActor !=nil || ![imageActor isEqualToString: @""]){
                        
                        Actor *newActor = [[Actor alloc]init:idActorString url:imageActor];
                        [actorInMovieDict setObject:newActor forKey:idActorString];
                        
                        [arrayIdActors addObject:idActorString];
                        
                        
                    }
                    // NSLog(@"URL : %@",imageActor);
                    // NSLog(@"ID ACTOR : %@",idActor);
                }
            }
            
            //  [[[UserConfig sharedInstance] movieList]setDictionary:moviesDict];
            //  [[UserConfig sharedInstance] archivingMovie:moviesDict];
            
            [[[UserConfig sharedInstance] actorInMovieList]setDictionary:actorInMovieDict];
            [[UserConfig sharedInstance] archivingActorInMovie: actorInMovieDict];
            
            // NSLog(@"Dico actor in movie : %@",[actorInMovieDict description]);
            
            
        }else{
            // [errorAlertView show];
        }
    }];
    
    
}
-(void)saveActorNotInMovie{
    actorNotInMovieDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 1; i <= 10; i++){
        
        
        int randomBool = arc4random() %(100)-1; //
        NSString* randomString = [NSString stringWithFormat:@"%d",randomBool];
        
        
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbPersonPopular  withParameters:@{@"page": randomString} andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
                for (NSDictionary *movieDic in moviesResult){
                    NSString *idActorString = @"",*imageActor=@"";
                    if ([movieDic objectForKey:@"name"]!=nil){
                        idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                        imageActor = [movieDic objectForKey:@"profile_path"];
                        if (idActorString !=nil || [idActorString isEqualToString:@""]|| imageActor !=nil || [imageActor isEqualToString:@""]){
                            Actor *newActor = [[Actor alloc]init:idActorString url:imageActor];
                            [actorNotInMovieDict setObject:newActor forKey:idActorString];
                        }
                    }
                    // NSLog(@"Dico actor not in movie : %@",[actorNotInMovieDict description]);
                    
                }
                [[[UserConfig sharedInstance] actorNotInMovieList]setDictionary:actorNotInMovieDict];
                [[UserConfig sharedInstance] archivingActorNotInMovie: actorNotInMovieDict];
                
            }else{
                // [errorAlertView show];
            }
        }];
    }
}
- (void) loadConfiguration {
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error)
            imagesBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        else
            [errorAlertView show];
    }];
}
+ (DataSourceManager*)sharedInstance
{
    static DataSourceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataSourceManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


@end

