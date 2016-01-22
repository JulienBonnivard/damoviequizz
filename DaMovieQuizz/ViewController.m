//
//  ViewController.m
//  DaMovieQuizz
//
//  Created by Julien MobileGlobe on 22/01/2016.
//  Copyright © 2016 JB. All rights reserved.
//

#import "ViewController.h"
#import "JLTMDbClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int actorNumberRandom = arc4random_uniform(74); // à définir en fonction du nombre d'acteurs
    int posterNumberRandom = arc4random_uniform(74); // à définir en fonction du nombre de films

    NSLog(@"random number : %i",actorNumberRandom);
    NSLog(@"random number : %i",posterNumberRandom);

    
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbMoviePopular withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if(!error){
        NSString*    fetchedData = response;
           NSLog(@"Popular Movies: %@",fetchedData);
        }
    }];
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbPersonPopular withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if(!error){
            NSString*    fetchedData = response;
            NSLog(@"Actor: %@",fetchedData);
        }
    }];
    //kJLTMDbPerson
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
