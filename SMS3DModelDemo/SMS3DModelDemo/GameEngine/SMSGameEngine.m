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

    GLuint _VBO;
    GLuint _VAO;
    SMSGLProgram *_program;
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
        [context asyncOnRenderingQueue:^{
            NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
            [runLoop run];
            [gameLoop addToRunLoop:runLoop forMode:NSRunLoopCommonModes];
        }];

        [self p_setupVAO];
        [self p_setupProgram];
    }
    return self;
}

- (void)p_setupVAO {
    [_context syncOnRenderingQueue:^{
        [self->_context.device makeCurrent];

        GLuint VAO;
        glGenVertexArrays(1, &VAO);
        self->_VAO = VAO;

        glBindVertexArray(VAO);

        float vertices[] = {
            -0.5f, -0.5f, 0.0f,
            0.5f, -0.5f, 0.0f,
            0.0f,  0.5f, 0.0f
        };
        GLuint VBO;
        glGenBuffers(1, &VBO);
        self->_VBO = VBO;
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);

        glBindVertexArray(0);
    }];
}

- (void)p_setupProgram {
    NSString *vertexShaderSource = @"#version 300 core\
    layout (location = 0) in vec3 aPos;\
    void main()\
    {\
       gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\
    }";

    NSString *fragmentShaderSource = @"#version 300 core\
    out highp vec4 FragColor;\
    void main()\
    {\
       FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\
    }";

    SMSGLProgram *program = [_context programWithVertexShaderString:vertexShaderSource fragmentShaderString:fragmentShaderSource];
    _program = program;
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
    NSLog(@"%s", __func__);
    if (!_isPlaying) {
        return;
    }

    BOOL isMainThread = [NSThread currentThread].isMainThread;
    NSCAssert(!isMainThread, @"");

    glBindFramebuffer(GL_FRAMEBUFFER, _drawableFBOName);
    glViewport(0, 0, _drawableSize.width, _drawableSize.height);
    glClearColor(0.2, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    [_program use];

    glBindVertexArray(_VAO);

    glDrawArrays(GL_TRIANGLES, 0, 3);

    glBindVertexArray(0);

    glBindRenderbuffer(GL_RENDERBUFFER, _drawableColorRenderBuffer);
    [[_context.device eaglContext] presentRenderbuffer:GL_RENDERBUFFER];
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)play {
    _isPlaying = YES;
}

- (void)pause {
    _isPlaying = NO;
}

@end
