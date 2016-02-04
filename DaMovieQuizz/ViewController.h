//
//  ViewController.h
//  DaMovieQuizz
//
//  Created by Julien on 22/01/2016.
//  Copyright © 2016 JB. All rights reserved.
//

#import "Actor.h"

@interface ViewController : UIViewController{
    NSString *urlFront;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    NSString* algoBoolActor;
    NSString *idActorRandom;
    BOOL firstGame;
    IBOutlet UILabel *bestScore;
}

@property (weak, nonatomic) IBOutlet UIImageView *movieCoverImageView;
@property (strong, nonatomic) NSDictionary *movieDict;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSMutableDictionary *actorInMovieDict;
@property (strong, nonatomic) NSMutableDictionary *actorInNotMovieDict;
@property (strong, nonatomic) NSMutableDictionary *gamerDict;


@property (strong, nonatomic) IBOutlet UIButton *startGameButton;
@property (strong, nonatomic) NSArray *moviesArray;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (copy, nonatomic) NSString *randomStringId;
@property (copy, nonatomic) NSString *imagesBaseUrlString;
@property (strong, nonatomic) IBOutlet UIImageView *actorCoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *progress;
@property(nonatomic, strong) NSMutableArray         *arrayMovie;
@property (copy, nonatomic) NSString *idMovie;
@property (copy, nonatomic) NSString *idActor;

@end

