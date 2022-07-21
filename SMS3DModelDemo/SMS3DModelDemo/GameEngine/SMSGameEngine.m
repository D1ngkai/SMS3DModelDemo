//
//  SMSGameEngine.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/7/21.
//

#import "SMSGameEngine.h"

#import "SMSGLContext.h"
#import "SMSWeakProxy.h"

@implementation SMSGameEngine {
    __weak id<EAGLDrawable> _drawable;
    CGSize _drawableSize;
    GLuint _drawableFBOName;
    GLuint _drawableColorRenderBuffer;
    GLuint _drawableDepthRenderBuffer;
    
    SMSGLContext *_context;
    
    CADisplayLink *_gameLoop;
    BOOL _isPlaying;
}

- (void)dealloc {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        SMSGLContext *context = [[SMSGLContext alloc] initWithDevice:[[SMSGLDevice alloc] init]];
        _context = context;
        
        SMSWeakProxy *weakProxy = [SMSWeakProxy proxyWithTarget:self];
        CADisplayLink *gameLoop = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(p_onGameLoop:)];
        gameLoop.preferredFramesPerSecond = 60;
        [context syncOnRenderingQueue:^{
            [gameLoop addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        }];
    }
    return self;
}

- (void)bindEAGLDrawable:(id<EAGLDrawable>)drawable {
    _drawable = drawable;
    
    [_context syncOnRenderingQueue:^{
        [self->_context.device makeCurrent];
        
        glGenFramebuffers(1, &self->_drawableFBOName);
        glBindFramebuffer(GL_FRAMEBUFFER, self->_drawableFBOName);
        
        glGenRenderbuffers(1, &self->_drawableColorRenderBuffer);
        
        glGenRenderbuffers(1, &self->_drawableDepthRenderBuffer);
        
        [self updateEAGLDrawableSize];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self->_drawableColorRenderBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, self->_drawableDepthRenderBuffer);
    }];
}

- (void)updateEAGLDrawableSize {
    [_context syncOnRenderingQueue:^{
        [self->_context.device makeCurrent];
        
        glBindRenderbuffer(GL_RENDERBUFFER, self->_drawableColorRenderBuffer);
        [[self->_context.device eaglContext] renderbufferStorage:GL_RENDERBUFFER fromDrawable:self->_drawable];
        
        CGSize drawableSize = [self p_getDrawableSize];
        self->_drawableSize = drawableSize;
        
        glBindRenderbuffer(GL_RENDERBUFFER, self->_drawableDepthRenderBuffer);
        
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, drawableSize.width, drawableSize.height);
    }];
}

- (CGSize)p_getDrawableSize {
    GLint width, height;
    glBindRenderbuffer(GL_RENDERBUFFER, _drawableColorRenderBuffer);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    CGSize drawableSize = CGSizeMake(width, height);
    return drawableSize;
}

- (void)p_onGameLoop:(CADisplayLink *)gameLoop {
    if (!_isPlaying) {
        return;
    }
}

- (void)play {
    _isPlaying = YES;
}

- (void)pause {
    _isPlaying = NO;
}

@end
