//
//  ViewController.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "ViewController.h"

#import "SMSGameWindow.h"

#define SCREEN_WIDTH [UIScreen.mainScreen bounds].size.width
#define SCREEN_HEIGHT [UIScreen.mainScreen bounds].size.height

@interface ViewController ()

@property (nonatomic) SMSGameWindow *gameWindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMSGameWindow *gameWindow = [[SMSGameWindow alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2.0, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.gameWindow = gameWindow;
    [self.view addSubview:gameWindow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gameWindow play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.gameWindow pause];
}

@end
