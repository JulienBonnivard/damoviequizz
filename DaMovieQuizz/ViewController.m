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
@synthesize moviesDict,arrayMovie,actorInMovieDict,randomStringId,idMovie,idActor,scoreLabel,progress,imagesBaseUrlString,actorInNotMovieDict,startGameButton,gamerDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    yesButton.enabled=NO;
    noButton.enabled=NO;
    yesButton.hidden=YES;
    noButton.hidden=YES;
    progress.hidden=YES;
    firstGame = YES;
    bestScore.text= [NSString stringWithFormat:@"Meilleur score : %@",[[UserConfig sharedInstance]bestScore]];
}

-(IBAction)beginGame:(id)sender{
    if (firstGame){
        moviesDict = [[UserConfig sharedInstance]loadMovie];
        actorInMovieDict = [[UserConfig sharedInstance]loadActorInMovie];
        actorInNotMovieDict = [[UserConfig sharedInstance]loadActorNotInMovie];
        gamerDict = [[UserConfig sharedInstance]loadGamer];
        urlFront =[[DataSourceManager sharedInstance]imagesBaseUrlString];
        firstGame= NO;
        scoreLabel.text=@"0";
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
    int secInt = [progress.text intValue];
    [progress setText:[NSString stringWithFormat:@"%d sec", secInt +1]];
}
-(void)loadGame{
    NSString *imageBackdrop;
    NSArray *array = [moviesDict allKeys];
    int random = arc4random()%[array count];
    randomStringId = [array objectAtIndex:random];
    
    [self loadActor : randomStringId];
    
    for(NSString *movie in moviesDict){
        if ([randomStringId isEqualToString:movie]){
            imageBackdrop = [urlFront stringByReplacingOccurrencesOfString:@"w92" withString:@"w500"];
            [self.movieCoverImageView setImageWithURL:[NSURL URLWithString:[imageBackdrop stringByAppendingString:[(Movie*)[moviesDict objectForKey:randomStringId]urlImage]]]];
            break;
        }
    }
}

-(void)loadActor : (NSString *)idMovieSend{
    @synchronized(self)
    {
        int randomBool = arc4random_uniform(2); //
        algoBoolActor = [NSString stringWithFormat:@"%d",randomBool];
        NSString *imageBackdrop;
        // NSLog(@"algoBool : %@ id moviesend %@" ,algoBoolActor, idMovieSend);
        
        if ([algoBoolActor isEqualToString:@"1"]){
            
            if( [[(Movie *)[moviesDict objectForKey:idMovieSend] idActors] allKeys] !=nil){
                NSArray *array =  [[(Movie *)[moviesDict objectForKey:idMovieSend]idActors] allKeys];
                int random = arc4random()%[array count];
                idActorRandom = [array objectAtIndex:random];
                
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
            else{
                [self loadActor:idMovieSend];
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
            [self saveScore];
            
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
        [self saveScore];
    }
}


-(void)saveScore{
    if(gamerDict == nil)
        gamerDict = [[NSMutableDictionary alloc] init];
    
    BOOL top10= YES;
    
    [self disableButtons];
    int scoreInt = [scoreLabel.text integerValue];
    int bestScoreInt =[[[UserConfig sharedInstance] bestScore ]integerValue];
    
    NSArray* allGamerScoreArray = [gamerDict allValues];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    allGamerScoreArray = [allGamerScoreArray sortedArrayUsingDescriptors:descriptors];
    
    int maxIndex = MIN(10, allGamerScoreArray.count) - 1;
    if (allGamerScoreArray.count < 10)
    {
        top10 = YES;
    }
    else if (maxIndex > 0)
    {
        Gamer* gamer = [allGamerScoreArray objectAtIndex:maxIndex];
        if ([scoreLabel.text integerValue] <= gamer.score){
            top10 = NO;
        }
        
    }
    if (top10 == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GAME OVER" message:[NSString stringWithFormat:@"Votre score : %@ \r Durée : %@",scoreLabel.text,progress.text] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [self stopTimer];
        scoreLabel.text=[NSString stringWithFormat:@"0"];
    }
    else{
        // use UIAlertController
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"GAME OVER"
                                   message:[NSString stringWithFormat:@"Votre score : %@ \r Durée : %@ \r Vous faites partie des 10 meilleurs joueurs, voulez-vous vous ajouter au classement ?",scoreLabel.text,progress.text]
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                       UITextField *textField = alert.textFields[0];
                                                       
                                                       int random1 = arc4random() %(1000)-1; //
                                                       NSString* randomString1 = [NSString stringWithFormat:@"%d",random1];
                                                       int random2 = arc4random() %(100000)-1; //
                                                       NSString* randomString2 = [NSString stringWithFormat:@"%d",random2];
                                                       NSString*idGamer = [NSString stringWithFormat:@"%@%@%@",randomString1,scoreLabel.text,randomString2];
                                                       
                                                       Gamer *newGamer = [[Gamer alloc] init:idGamer score:scoreLabel.text name:textField.text time:progress.text];
                                                       [gamerDict setObject:newGamer forKey:idGamer];
                                                       [[[UserConfig sharedInstance] gamerList]setDictionary:gamerDict];
                                                       [[UserConfig sharedInstance] archivingGamer:gamerDict];
                                                       
                                                       [self stopTimer];
                                                       scoreLabel.text=[NSString stringWithFormat:@"0"];
                                                       
                                                       [self highScoringScreen];
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           NSLog(@"cancel btn");
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                           [self highScoringScreen];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Saisissez votre nom";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        if (scoreInt > bestScoreInt){
            [[UserConfig sharedInstance]setBestScore:scoreLabel.text];
            [[UserConfig sharedInstance]Save];
            [[UserConfig sharedInstance]Load];
        }
        bestScore.text=[NSString stringWithFormat:@"Meilleur score : %@",[[UserConfig sharedInstance]bestScore]];
    }
    
}
-(void)highScoringScreen{
    
    NSArray* allGamerScoreArray = [gamerDict allValues];
    bestPlayersArray = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    allGamerScoreArray = [allGamerScoreArray sortedArrayUsingDescriptors:descriptors];
    
    NSUInteger maxIndex  = MIN([allGamerScoreArray count], 10);
    NSUInteger i = 0;
 
    
    for (i=0 ; i < maxIndex;i++){
        
        Gamer *gamer = [allGamerScoreArray objectAtIndex:i];
        
        NSUInteger intScore= gamer.score;
        NSString *score = [NSString stringWithFormat:@"%d",intScore];
        NSString *name =gamer.name;
        NSString *time = gamer.time;
        
        bestPlayers = [NSString stringWithFormat:@"Nom: %@ Score: %@ Temps: %@ \r", name,score,time];
        [bestPlayersArray addObject:bestPlayers];
    }
    
    NSString * result = [[bestPlayersArray valueForKey:@"description"] componentsJoinedByString:@"\r"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Top 10" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
