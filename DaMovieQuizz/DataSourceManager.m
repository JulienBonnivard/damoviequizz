#import "JLTMDbClient.h"
#import "DataSourceManager.h"
#import "Actor.h"
#import "Movie.h"

@implementation DataSourceManager

@synthesize actorInMovieDict,actorNotInMovieDict,moviesDict,idMovie,imagesBaseUrlString;

-(void)saveMovie{
    moviesDict =[[NSMutableDictionary alloc] init];
    
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erreur lors de la sauvegarde des films", @"") message:NSLocalizedString(@"Veuillez relancer l'application", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    
    //[moviesDict removeAllObjects];
    for (int i = 1; i <= 4; i++){
        
        int randomBool = arc4random() %(30)-1; //
        NSString* randomString = [NSString stringWithFormat:@"%d",randomBool];
        
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:@{@"page": randomString} andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                
                NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
                
                for (NSDictionary *movieDic in moviesResult){
                    NSString *posterURL = @"";
                    
                    if ([movieDic objectForKey:@"poster_path" ] == [NSNull null]) {
                    }
                    
                    else{
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
                }
                //   NSLog(@"COUNT ARRAY MOVIES : %lu et RANDOM ID : %@", (unsigned long)[array count], randomStringId);
                //   NSLog(@"DICO MOVIE : %@", [[[UserConfig sharedInstance]movieList]description]);
            }else{
                [errorAlertView show];
            }
        }];
    }
}
-(void)saveActorInMovie : (NSString *)idMovieSend posterURL:(NSString*)posterURL{
    if(actorInMovieDict == nil)
        actorInMovieDict = [[NSMutableDictionary alloc] init];
    
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovieSend} andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableDictionary* actorForAMovieDict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* actorsDico = [response objectForKey:@"cast"];
            //    if (actorsDico [@"profile_path"]!=[NSNull null]){
            //        NSLog(@"POUETTTE");
            //    }
            for (NSDictionary *actorDic in actorsDico){
                NSString *idActorString = @"",*imageActor=@"";
                
                
                if ([actorDic objectForKey:@"name"]!=nil){
                    
                    if ([actorDic objectForKey:@"profile_path" ] == [NSNull null] || [actorDic objectForKey:@"name"] == [NSNull null]){
                        
                        //   NSLog(@"VIDE  profile : %@ ou name : %@",[actorDic objectForKey:@"profile_path" ],[actorDic objectForKey:@"profile_path" ]);
                        
                    }
                    else{
                        idActorString = [NSString stringWithFormat:@"%@",[actorDic objectForKey:@"id"]];
                        imageActor = [actorDic objectForKey:@"profile_path"];
                        
                        
                        Actor *newActor = [[Actor alloc]init:idActorString url:imageActor];
                        [actorForAMovieDict setObject:newActor forKey:idActorString];
                        [actorInMovieDict setObject:newActor forKey:idActorString];
                        
                        Movie* movie = [moviesDict objectForKey:idMovieSend];
                        [movie setIdActors:actorForAMovieDict];
                        
                        [moviesDict setObject:movie forKey:idMovieSend];
                        //  NSLog(@"COMPLET : %@ et %@", idActorString,imageActor);
                    }
                    
                    //  NSLog(@"\nMovie id %@ actor %@\n", idMovieSend, [actorDic objectForKey:@"name"]);
                    //  NSLog(@"id actor : %@ et  image ACTOR: %@",idActorString,imageActor);
                    
                }
            }
            
            [[[UserConfig sharedInstance] movieList]setDictionary:moviesDict];
            [[UserConfig sharedInstance] archivingMovie:moviesDict];
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
        
        int randomBool = arc4random() %(30)-1; //
        NSString* randomString = [NSString stringWithFormat:@"%d",randomBool];
        
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbPersonPopular  withParameters:@{@"page": randomString} andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
                for (NSDictionary *actorDic in moviesResult){
                    NSString *idActorString = @"",*imageActor=@"";
                    if ([actorDic objectForKey:@"profile_path" ] == [NSNull null] || [actorDic objectForKey:@"name"] == [NSNull null]){
                    }
                    else{
                        idActorString = [NSString stringWithFormat:@"%@",[actorDic objectForKey:@"id"]];
                        imageActor = [actorDic objectForKey:@"profile_path"];
                        if (idActorString !=nil || ![idActorString isEqualToString:@""]|| imageActor !=nil || ![imageActor isEqualToString:@""]){
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
- (void) loadConfiguration{
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erreur lors de la sauvegarde de la configuration", @"") message:NSLocalizedString(@"Veuillez fermer l'application et relancer", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error)
            imagesBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        else
            [errorAlertView show];
    }];
}
+ (DataSourceManager*)sharedInstance{
    static DataSourceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataSourceManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


@end

