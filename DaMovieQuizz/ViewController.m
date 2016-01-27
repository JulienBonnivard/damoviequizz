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

@interface ViewController ()
@end

@implementation ViewController
@synthesize moviesDict,arrayMovie,actorInMovieDict,randomStringId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConfiguration];
    [self refresh];
    [self loadGame];
    // Do any additional setup after loading the view, typically from a nib.
    randomStringId=@"";

    
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
    moviesDict =[[NSMutableDictionary alloc] init];
    actorInMovieDict =[[NSMutableDictionary alloc]init];
    
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
                    [moviesDict setObject:posterURL forKey:idMovies];
                    
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
                if (randomStringId == idMovie){
                    imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                    [self.movieCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[moviesDict objectForKey:randomStringId]]]];
                    break;
                }
            }
            //   NSLog(@"COUNT ARRAY MOVIES : %lu et RANDOM ID : %@", (unsigned long)[array count], randomStringId);
            //   NSLog(@"DICO MOVIE : %@", [moviesDict description]);
            
        }else{
            // [errorAlertView show];
        }
    }];
    
}
-(void)loadActor : (NSString *)idMovie{
    NSString* algoBoolActor;
       int randomBool = arc4random_uniform(2); //
    algoBoolActor = [NSString stringWithFormat:@"%d",randomBool];
    
    __block NSString *imageBackdrop;
    if ([algoBoolActor isEqualToString:@"1"]){
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMovieCasts  withParameters:@{@"id": idMovie} andResponseBlock:^(id response, NSError *error) {
        if (!error) {
            NSMutableDictionary* moviesResult = [response objectForKey:@"cast"];
            for (NSDictionary *movieDic in moviesResult){
                NSString *idActor = @"",*imageActor=@"";
                if ([movieDic objectForKey:@"name"]!=nil){
                    idActor = [movieDic objectForKey:@"id"];
                    imageActor = [movieDic objectForKey:@"profile_path"];
                    [actorInMovieDict setObject:imageActor forKey:idActor];
                
                    // NSLog(@"URL : %@",imageActor);
                    // NSLog(@"ID ACTOR : %@",idActor);
                }
            }
            
            NSArray *array = [actorInMovieDict allKeys]; int random = arc4random()%[array count];
            NSString *key = [array objectAtIndex:random];
            
            for(NSString *urlMovie in actorInMovieDict){
                if (key == urlMovie){
                    imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                    [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[actorInMovieDict objectForKey:key]]]];
                    break;
                }
            }
            
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
                    NSString *idActor = @"",*imageActor=@"";
                    if ([movieDic objectForKey:@"name"]!=nil){
                        idActor = [movieDic objectForKey:@"id"];
                        imageActor = [movieDic objectForKey:@"profile_path"];
                        [actorInMovieDict setObject:imageActor forKey:idActor];
                        
                        // NSLog(@"URL : %@",imageActor);
                        // NSLog(@"ID ACTOR : %@",idActor);
                    }
                }
                
                NSArray *array = [actorInMovieDict allKeys]; int random = arc4random()%[array count];
                NSString *key = [array objectAtIndex:random];
                
                for(NSString *urlMovie in actorInMovieDict){
                    if (key == urlMovie){
                        imageBackdrop = [self.imagesBaseUrlString stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                        [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[actorInMovieDict objectForKey:key]]]];
                        break;
                    }
                }
                
                //NSLog(@"DICO ACTOR IN MOVIE : %@",[moviesDict description]);
                //[userConfig archivingActor:userConfig.actorList];
                //NSLog(@"actorlist : %@",userConfig.actorList);
            }else{
                // [errorAlertView show];
            }
        }];
   
    }
}
-(IBAction)yesButton:(id)sender{
    [self loadGame];
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
