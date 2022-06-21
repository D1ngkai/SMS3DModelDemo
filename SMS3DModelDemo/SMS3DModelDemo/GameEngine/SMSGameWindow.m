//
//  SMSGameWindow.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import "SMSGameWindow.h"

@implementation SMSGameWindow {
    BOOL _isInBackground;
    BOOL _isVisible;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setup];
    }
    return self;
}

- (void)p_setup {
    self.contentScaleFactor = [UIScreen mainScreen].scale;
    self.backgroundColor = [UIColor clearColor];

    _isInBackground = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    _isVisible = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    [super setBounds:bounds];
    if (oldBounds.size.width != bounds.size.width ||
        oldBounds.size.height != bounds.size.height) {
//        [pagSurface updateSize];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldRect = self.frame;
    [super setFrame:frame];
    if (oldRect.size.width != frame.size.width ||
        oldRect.size.height != frame.size.height) {
//        [pagSurface updateSize];
    }
}

- (void)setContentScaleFactor:(CGFloat)scaleFactor {
    CGFloat oldScaleFactor = self.contentScaleFactor;
    [super setContentScaleFactor:scaleFactor];
    if (oldScaleFactor != scaleFactor) {
//        [pagSurface updateSize];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self p_checkVisible];
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    [self p_checkVisible];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self p_checkVisible];
}

- (void)p_checkVisible {
    BOOL visible = self.window && !self.isHidden && self.alpha > 0.0;
    if (_isVisible == visible) {
        return;
    }
    _isVisible = visible;
    if (_isVisible) {
        [self p_startPlaying];
    } else {
        [self p_stopPlaying];
    }
}

- (void)p_startPlaying {

}

- (void)p_stopPlaying {

}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    _isInBackground = NO;
    if (_isVisible) {
        [self p_startPlaying];
    }
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    _isInBackground = YES;
    [self p_stopPlaying];
}


@end
