//
//  ViewController.h
//  DaMovieQuizz
//
//  Created by Julien MobileGlobe on 22/01/2016.
//  Copyright © 2016 JB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *movieCoverImageView;
@property (strong, nonatomic) NSDictionary *movieDict;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSMutableDictionary *actorInMovieDict;


@property (strong, nonatomic) NSArray *moviesArray;

@property (copy, nonatomic) NSString *randomStringId;


@property (copy, nonatomic) NSString *imagesBaseUrlString;
@property (strong, nonatomic) IBOutlet UIImageView *actorCoverImageView;


@property(nonatomic, strong) NSMutableArray         *arrayMovie;



@end

