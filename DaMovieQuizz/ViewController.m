//
//  ViewController.m
//  DaMovieQuizz
//
//  Created by Julien MobileGlobe on 22/01/2016.
//  Copyright © 2016 JB. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"
//#import "UserConfig.h"
#import "JLTMDbClient.h"

@interface ViewController (){
    NSTimer *_timer;
}
- (void)_timerFired:(NSTimer *)timer;
@end

@implementation ViewController
@synthesize moviesDict,arrayMovie,actorInMovieDict,randomStringId,idMovie,idActor,scoreLabel,progress;

- (void)viewDidLoad {
    [super viewDidLoad];
    moviesDict =[[NSMutableDictionary alloc] init];
    actorInMovieDict =[[NSMutableDictionary alloc]init];
    
    [self loadConfiguration];
    [self refresh];
    [self loadGame];
    // Do any additional setup after loading the view, typically from a nib.
    randomStringId=@"";
    
    [self startTimer];
    
}
-(void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(_timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}
-(void)stopTimer{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}
- (void)_timerFired:(NSTimer *)timer {
    //NSLog(@"ping");
//    if ([progress.text intValue]== 60){
//        int secInt = [progress.text intValue];
//        int minIn = 1;
//        [progress setText:[NSString stringWithFormat:@" %d min %d sec", minIn +1 ,secInt +1]];
//        
//    }else{
        int secInt = [progress.text intValue];
        [progress setText:[NSString stringWithFormat:@"%d sec", secInt +1]];
   // }
}
-(void)loadGame{
    //__block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    __block NSString *imageBackdrop;
    
    //    int posterNumberRandom = arc4random_uniform(20); // à définir en fonction du nombre de films
    //    int actorNumberRandom = arc4random_uniform(80); // à définir en fonction du nombre d'acteurs
    //
    //    NSLog(@"random number : %i",posterNumberRandom);
    //    NSLog(@"random number : %i",actorNumberRandom);
    
    //NSString *movieId = @(posterNumberRandom).stringValue;
    //   NSString *movieId =@"206647";
    
    //  arrayMovie = [[NSMutableArray alloc] init];
    [moviesDict removeAllObjects];
    
    
    // NSDictionary *movieDict = self.moviesArray;
    // NSString *actorId = @"976";
    //kJLTMDbMovie
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            
            NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
            
            for (NSDictionary *movieDic in moviesResult){
                NSString *posterURL = @"",*idMovies=@"";
                if ([movieDic objectForKey:@"poster_path"]!=nil){
                    posterURL = [movieDic objectForKey:@"poster_path"];
                    idMovies=[NSString stringWithFormat:@"%@", [movieDic objectForKey:@"id"]];
                    //idMovies = [NSString stringWithFormat:@"%@"],[movieDic objectForKey:@"id"];
                    // NSLog(@"URL : %@",posterURL);
                    // NSLog(@"ID MOVIE : %@",idMovies);
                    // [arrayMovie addObject:idMovies];
                    if(posterURL !=nil || [posterURL isEqualToString:@""]){
                        
                        [moviesDict setObject:posterURL forKey:idMovies];
                    }
                    //  imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                    //  [self.movieCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:posterURL]]];
                }
            }
            
            NSArray *array = [moviesDict allKeys];
            int random = arc4random()%[array count];
            randomStringId = [array objectAtIndex:random];
            if (randomStringId !=nil){
                [self loadActor : randomStringId];
            }
            for(NSString *idMovie in moviesDict){
                if ([randomStringId isEqualToString:idMovie]){
                    imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                    [self.movieCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[moviesDict objectForKey:randomStringId]]]];
                    break;
                }
            }
            //   NSLog(@"COUNT ARRAY MOVIES : %lu et RANDOM ID : %@", (unsigned long)[array count], randomStringId);
            //   NSLog(@"DICO MOVIE : %@", [moviesDict description]);
            [self ParamIdMovie:randomStringId];
        }else{
            // [errorAlertView show];
        }
    }];
    
}
-(void)ParamIdMovie : (NSString*)movieId{
    
    idMovie=movieId ;
    
}
-(void)loadActor : (NSString *)idMovieSend{
    [actorInMovieDict removeAllObjects];
    
    NSString* algoBoolActor;;
    int randomBool = arc4random_uniform(2); //
    algoBoolActor = [NSString stringWithFormat:@"%d",randomBool];
    
    __block NSString *imageBackdrop;
    if ([algoBoolActor isEqualToString:@"1"]){
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovieSend} andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                NSMutableDictionary* moviesResult = [response objectForKey:@"cast"];
                for (NSDictionary *movieDic in moviesResult){
                    NSString *idActorString = @"",*imageActor=@"";
                    if ([movieDic objectForKey:@"name"]!=nil){
                        idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                        imageActor = [movieDic objectForKey:@"profile_path"];
                        if(imageActor !=nil || [imageActor isEqualToString:@""]){
                            [actorInMovieDict setObject:imageActor forKey:idActorString];
                        }
                        
                        // NSLog(@"URL : %@",imageActor);
                        // NSLog(@"ID ACTOR : %@",idActor);
                    }
                }
                
                NSArray *array = [actorInMovieDict allKeys]; int random = arc4random()%[array count];
                NSString *idActorRandom = [array objectAtIndex:random];
                
                for(NSString *urlMovie in actorInMovieDict){
                    if ([idActorRandom isEqualToString: urlMovie]){
                        imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                        [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[actorInMovieDict objectForKey:idActorRandom]]]];
                        break;
                    }
                }
                [self ParamIdActor:idActorRandom];
                
                //NSLog(@"DICO ACTOR IN MOVIE : %@",[moviesDict description]);
                //[userConfig archivingActor:userConfig.actorList];
                //NSLog(@"actorlist : %@",userConfig.actorList);
            }else{
                // [errorAlertView show];
            }
        }];
    }
    else{
        [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbPersonPopular  withParameters:nil andResponseBlock:^(id response, NSError *error) {
            if (!error) {
                NSMutableDictionary* moviesResult = [response objectForKey:@"results"];
                for (NSDictionary *movieDic in moviesResult){
                    NSString *idActorString = @"",*imageActor=@"";
                    if ([movieDic objectForKey:@"name"]!=nil){
                        idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                        imageActor = [movieDic objectForKey:@"profile_path"];
                        if(imageActor !=nil || [imageActor isEqualToString:@""]){
                            [actorInMovieDict setObject:imageActor forKey:idActorString];
                        }
                        // NSLog(@"URL : %@",imageActor);
                        // NSLog(@"ID ACTOR : %@",idActor);
                    }
                }
                
                NSArray *array = [actorInMovieDict allKeys]; int random = arc4random()%[array count];
                NSString *idActorRandom = [array objectAtIndex:random];
                
                for(NSString *urlMovie in actorInMovieDict){
                    if ([idActorRandom isEqualToString:urlMovie]){
                        imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                        [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[actorInMovieDict objectForKey:idActorRandom]]]];
                        break;
                    }
                }
                [self ParamIdActor:idActorRandom];
                //NSLog(@"DICO ACTOR IN MOVIE : %@",[moviesDict description]);
                //[userConfig archivingActor:userConfig.actorList];
                //NSLog(@"actorlist : %@",userConfig.actorList);
            }else{
                // [errorAlertView show];
            }
        }];
        
    }
}
-(void)ParamIdActor : (NSString*)actorId{
    
    idActor=actorId ;
    
}
-(IBAction)yesButton:(id)sender{
    __block BOOL goodAnswer = NO;
    [actorInMovieDict removeAllObjects];
    
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovie} andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableDictionary* moviesResult = [response objectForKey:@"cast"];
            for (NSDictionary *movieDic in moviesResult){
                NSString *idActorString = @"",*imageActor=@"";
                if ([movieDic objectForKey:@"name"]!=nil){
                    idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                    [actorInMovieDict setObject:imageActor forKey:idActorString];
                    
                    // NSLog(@"URL : %@",imageActor);
                    // NSLog(@"ID ACTOR : %@",idActor);
                }
            }
            for (NSString *idActorOnScreen in actorInMovieDict){
                if ([idActorOnScreen isEqualToString: idActor]){
                    int scoreInt = [scoreLabel.text intValue];
                    
                    [scoreLabel setText:[NSString stringWithFormat:@"%d", scoreInt +1]];
                    
                    [self loadGame];
                    goodAnswer=YES;
                    break;
                    
                }
                else{
                    
                }
            }
            
            if (!goodAnswer){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LOOSER" message:@"GAME OVER" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                scoreLabel.text=@"0";
                
            }
        }
    }];
    NSLog(@"ID MOVIE = %@ ET ID ACTOR =%@",idMovie,idActor);
    
}
-(IBAction)noButton:(id)sender{
    __block BOOL badAnswer = NO;
    
    [actorInMovieDict removeAllObjects];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovie} andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableDictionary* moviesResult = [response objectForKey:@"cast"];
            for (NSDictionary *movieDic in moviesResult){
                NSString *idActorString = @"",*imageActor=@"";
                if ([movieDic objectForKey:@"name"]!=nil){
                    idActorString = [NSString stringWithFormat:@"%@",[movieDic objectForKey:@"id"]];
                    [actorInMovieDict setObject:imageActor forKey:idActorString];
                    
                    // NSLog(@"URL : %@",imageActor);
                    // NSLog(@"ID ACTOR : %@",idActor);
                }
            }
            for (NSString *idActorOnScreen in actorInMovieDict){
                if ([idActorOnScreen isEqualToString:idActor]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LOOSER" message:@"GAME OVER" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    scoreLabel.text=@"0";
                    badAnswer =YES;
                    break;
                    
                }
                else{
                    
                    
                }
            }
            if (badAnswer ==NO){
                int scoreInt = [scoreLabel.text intValue];
                
                [scoreLabel setText:[NSString stringWithFormat:@"%d", scoreInt +1]];
                
                [self loadGame];
                NSLog(@"JE RENTRE ICI");
                
            }
        }
    }];
    NSLog(@"ID MOVIE = %@ ET ID ACTOR =%@",idMovie,idActor);
    
}
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0U;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return (NSDictionary *)mutableDictionary;
}
#pragma mark - Private Methods

- (void) loadConfiguration {
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error)
            self.imagesBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        else
            [errorAlertView show];
    }];
}
- (void) refresh {
    NSArray *optionsArray = @[kJLTMDbMoviePopular, kJLTMDbMovieUpcoming, kJLTMDbMovieTopRated];
    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    [[JLTMDbClient sharedAPIInstance] GET:optionsArray[arc4random() % [optionsArray count]] withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            self.moviesArray = response[@"results"];
            // [self.tableView reloadData];
        }else
            [errorAlertView show];
        // [self.refreshControl endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
