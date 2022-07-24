//
//  SMSGameWindow.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import "SMSGameWindow.h"

#import "SMSGameEngine.h"

@implementation SMSGameWindow {
    BOOL _isInBackground;
    BOOL _isVisible;
    
    SMSGameEngine *_gameEngine;
    BOOL _isPlaying;
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
    self.contentScaleFactor = [UIScreen mainScreen].nativeScale;
    self.backgroundColor = [UIColor clearColor];

    _isInBackground = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    _isVisible = NO;
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.drawableProperties = @{
        kEAGLDrawablePropertyRetainedBacking : @NO,
        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
    };
    eaglLayer.opaque = YES;
    
    _gameEngine = [[SMSGameEngine alloc] init];
    [_gameEngine bindEAGLDrawable:eaglLayer];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    _isInBackground = NO;
    if (_isVisible) {
        [self play];
    }
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    _isInBackground = YES;
    [self pause];
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    [super setBounds:bounds];
    if (oldBounds.size.width != bounds.size.width ||
        oldBounds.size.height != bounds.size.height) {
        [_gameEngine updateEAGLDrawableSize];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldRect = self.frame;
    [super setFrame:frame];
    if (oldRect.size.width != frame.size.width ||
        oldRect.size.height != frame.size.height) {
        [_gameEngine updateEAGLDrawableSize];
    }
}

- (void)setContentScaleFactor:(CGFloat)scaleFactor {
    CGFloat oldScaleFactor = self.contentScaleFactor;
    [super setContentScaleFactor:scaleFactor];
    if (oldScaleFactor != scaleFactor) {
        [_gameEngine updateEAGLDrawableSize];
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
}

#pragma mark - Implement

- (BOOL)isPlaying {
    return _isPlaying;
}

- (void)play {
    if (_isPlaying) {
        return;
    }
    
    _isPlaying = YES;
    [_gameEngine play];
}

- (void)pause {
    if (!_isPlaying) {
        return;
    }
    
    _isPlaying = NO;
    [_gameEngine pause];
}

- (void)W {
    [_gameEngine W];
}

- (void)A {
    [_gameEngine A];
}

- (void)S {
    [_gameEngine S];
}

- (void)D {
    [_gameEngine D];
}

@end
