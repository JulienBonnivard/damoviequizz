//  ViewController.m
//  DaMovieQuizz
//
//  Created by Julien on 22/01/2016.
//  Copyright © 2016 JB. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"
#import "JLTMDbClient.h"

@interface ViewController (){
    NSTimer *_timer;
}
- (void)_timerFired:(NSTimer *)timer;
@end

@implementation ViewController
@synthesize moviesDict,arrayMovie,actorInMovieDict,randomStringId,idMovie,idActor,scoreLabel,progress,imagesBaseUrlString,actorInNotMovieDict,startGameButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    yesButton.enabled=NO;
    noButton.enabled=NO;
    yesButton.hidden=YES;
    noButton.hidden=YES;
    progress.hidden=YES;
    firstGame = YES;
}

-(IBAction)beginGame:(id)sender{
    if (firstGame){
        moviesDict = [[UserConfig sharedInstance]loadMovie];
        actorInMovieDict = [[UserConfig sharedInstance]loadActorInMovie];
        actorInNotMovieDict = [[UserConfig sharedInstance]loadActorNotInMovie];
        urlFront =[[DataSourceManager sharedInstance]imagesBaseUrlString];
        
        firstGame= NO;
    }
    // NSLog(@"count :%lu",  (unsigned long)[actorInNotMovieDict count]);
    progress.hidden= NO;
    [self startTimer];
    [self loadGame];
    
    [self enableButtons];
}
-(void)enableButtons{
    startGameButton.hidden=YES;
    startGameButton.enabled=NO;
    
    yesButton.enabled=YES;
    noButton.enabled=YES;
    yesButton.hidden=NO;
    noButton.hidden=NO;
}
-(void)disableButtons{
    yesButton.enabled=NO;
    noButton.enabled=NO;
    yesButton.hidden=YES;
    noButton.hidden=YES;
    startGameButton.hidden=NO;
    startGameButton.enabled=YES;
    
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
    [progress setText:@"0 sec"];
    _timer = nil;
}

- (void)_timerFired:(NSTimer *)timer {
    
    //Timer avec minutes et secondes à afficher
    
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
    
    NSString *imageBackdrop;
    NSArray *array = [moviesDict allKeys];
    int random = arc4random()%[array count];
    randomStringId = [array objectAtIndex:random];
    if (randomStringId !=nil){
        [self loadActor : randomStringId];
    }
    for(NSString *movie in moviesDict){
        if ([randomStringId isEqualToString:movie]){
            imageBackdrop = [urlFront stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
            [self.movieCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[(Movie*)[moviesDict objectForKey:randomStringId]urlImage]]]];
            break;
        }
    }
}

-(void)loadActor : (NSString *)idMovieSend{
    
    int randomBool = arc4random_uniform(2); //
    algoBoolActor = [NSString stringWithFormat:@"%d",randomBool];
    //algoBoolActor =@"1";
    NSString *imageBackdrop;
    
    if ([algoBoolActor isEqualToString:@"1"]){
        if( [[(Movie *)[moviesDict objectForKey:idMovieSend]idActors] allKeys] !=nil){
            NSArray *array =  [[(Movie *)[moviesDict objectForKey:idMovieSend]idActors] allKeys];
            
            int random = arc4random()%[array count];
            idActorRandom = [array objectAtIndex:random];
            
            //ressort tous les acteurs dans les films qu'on a mis récupérer mais pas tous les acteurs du films affiché ( ajouter une deuxieme rêquete pour affiner la recherche)
            for(NSString *idActorfFromMovie in [(Movie *)[moviesDict objectForKey:idMovieSend]idActors]){
                //           if (actorInMovieDict != [NSNull null]) {
                if ([idActorRandom isEqualToString: idActorfFromMovie]){
                    imageBackdrop = [urlFront stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                    NSLog(@"Réponse oui");
                    
                    [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[(Actor*)[actorInMovieDict objectForKey:idActorRandom]urlImage]]]];
                    
                    break;
                }
            }
        }
        //NSLog(@"DICO ACTOR IN MOVIE : %@",[moviesDict description]);
        //NSLog(@"actorlist : %@",userConfig.actorList);
    }
    
    else{
        NSArray *array = [actorInNotMovieDict allKeys]; int random = arc4random()%[array count];
        idActorRandom = [array objectAtIndex:random];
        for(NSString *urlMovie in actorInNotMovieDict){
            if ([idActorRandom isEqualToString:urlMovie]){
                imageBackdrop = [urlFront stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
                NSLog(@"Réponse non");
                [self.actorCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[(Actor*)[actorInNotMovieDict objectForKey:idActorRandom]urlImage]]]];
                break;
            }
        }
    }
}

-(IBAction)yesButton:(id)sender{
    BOOL goodAnswer = NO;
    
    if ([algoBoolActor isEqualToString:@"1"]){
        int scoreInt = [scoreLabel.text intValue];
        [scoreLabel setText:[NSString stringWithFormat:@"%d", scoreInt +1]];
        [self loadGame];
        goodAnswer=YES;
    }
    else{
        if (!goodAnswer){
            [self stopTimer];
            [self disableButtons];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LOOSER" message:@"GAME OVER" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            scoreLabel.text=@"0";
        }
    }
}
-(IBAction)noButton:(id)sender{
    
    if (![algoBoolActor isEqualToString:@"1"]){
        int scoreInt = [scoreLabel.text intValue];
        [scoreLabel setText:[NSString stringWithFormat:@"%d", scoreInt +1]];
        [self loadGame];
    }
    
    else{
        [self stopTimer];
        [self disableButtons];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LOOSER" message:@"GAME OVER" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        scoreLabel.text=[NSString stringWithFormat:@"0"];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
