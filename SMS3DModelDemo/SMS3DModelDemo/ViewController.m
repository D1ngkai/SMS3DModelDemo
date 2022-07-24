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
@property (weak, nonatomic) IBOutlet UIButton *w;
@property (weak, nonatomic) IBOutlet UIButton *s;
@property (weak, nonatomic) IBOutlet UIButton *a;
@property (weak, nonatomic) IBOutlet UIButton *d;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMSGameWindow *gameWindow = [[SMSGameWindow alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2.0, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.gameWindow = gameWindow;
    [self.view addSubview:gameWindow];
    
    UILongPressGestureRecognizer *l1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onW:)];
    l1.minimumPressDuration = 0;
    [_w addGestureRecognizer:l1];
    
    UILongPressGestureRecognizer *l2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onS:)];
    l2.minimumPressDuration = 0;
    [_s addGestureRecognizer:l2];
    
    UILongPressGestureRecognizer *l3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onA:)];
    l3.minimumPressDuration = 0;
    [_a addGestureRecognizer:l3];
    
    UILongPressGestureRecognizer *l4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onD:)];
    l4.minimumPressDuration = 0;
    [_d addGestureRecognizer:l4];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gameWindow play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.gameWindow pause];
}

- (void)onS:(UILongPressGestureRecognizer *)longPress {
    [_gameWindow S];
}

- (void)onW:(UILongPressGestureRecognizer *)longPress {
    [_gameWindow W];
}

- (void)onA:(UILongPressGestureRecognizer *)longPress {
    [_gameWindow A];
}

- (void)onD:(UILongPressGestureRecognizer *)longPress {
    [_gameWindow D];
}

@end
