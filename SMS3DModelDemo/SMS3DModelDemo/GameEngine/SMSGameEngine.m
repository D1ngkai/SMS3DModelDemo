//
//  SMSGameEngine.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/7/21.
//

#import "SMSGameEngine.h"

#import "SMSGLContext.h"
#import "SMSWeakProxy.h"

#import "AAPLMathUtilities.h"

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
    GLuint _EBO;
    SMSGLProgram *_program;
    id<SMSGLTexture> _texture;
    
    simd_float3 _cameraPos;
    simd_float3 _cameraFront;
    simd_float3 _cameraUp;
    float _deltaTime;
    float _lastFrame;
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
        [gameLoop addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        
        _cameraPos = simd_make_float3(0, 0, 3);
        _cameraFront = simd_make_float3(0, 0, -1);
        _cameraUp = simd_make_float3(0, 1, 0);
        _deltaTime = 0;
        _lastFrame = 0;

        [self p_setupVAO];
        [self p_setupProgram];
        [self p_setupTexture];
    }
    return self;
}

- (void)p_setupVAO {
    [_context syncOnRenderingQueue:^{
//        float vertices[] = {
//            //     ---- 位置 ----       ---- 颜色 ----     - 纹理坐标 -
//             0.5f,  0.5f, 0.0f,  1.0f, 0.0f, 0.0f,  1.0f, 1.0f,   // 右上
//             0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,  1.0f, 0.0f,   // 右下
//            -0.5f, -0.5f, 0.0f,  0.0f, 0.0f, 1.0f,  0.0f, 0.0f,   // 左下
//            -0.5f,  0.5f, 0.0f,  1.0f, 1.0f, 0.0f,  0.0f, 1.0f    // 左上
//        };
        
        float vertices[] = {
            -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
            0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
            0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
            
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
            0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
            0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
            -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            
            -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            
            0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
            0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
            0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
            
            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
            0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
            0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
            -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
            -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
        };
        
        unsigned int indices[] = {
            0, 1, 3, // 第一个三角形
            1, 2, 3  // 第二个三角形
        };
        
        [self->_context.device makeCurrent];
        
        GLuint EBO;
        glGenBuffers(1, &EBO);
        self->_EBO = EBO;
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

        GLuint VAO;
        glGenVertexArrays(1, &VAO);
        self->_VAO = VAO;

        glBindVertexArray(VAO);
        
        GLuint VBO;
        glGenBuffers(1, &VBO);
        self->_VBO = VBO;
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

//        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
//        glEnableVertexAttribArray(0);
//        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
//        glEnableVertexAttribArray(1);
//        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(6 * sizeof(float)));
//        glEnableVertexAttribArray(2);
        
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);

        glBindVertexArray(0);
    }];
}

- (void)p_setupProgram {
    NSString *vertexShaderSource = @"#version 300 core\
    layout (location = 0) in vec3 aPos;\
    layout (location = 1) in vec2 aTexCoord;\
    out vec2 TexCoord;\
    uniform mat4 model;\
    uniform mat4 view;\
    uniform mat4 projection;\
    void main()\
    {\
        gl_Position = projection * view * model * vec4(aPos, 1.0);\
        TexCoord = aTexCoord;\
    }";

    NSString *fragmentShaderSource = @"#version 300 core\
    precision highp float;\
    out vec4 FragColor;\
    in vec2 TexCoord;\
    uniform sampler2D ourTexture;\
    void main()\
    {\
        vec2 uv = vec2(TexCoord.x, 1.0 - TexCoord.y);\
        FragColor = texture(ourTexture, uv);\
    }";

    SMSGLProgram *program = [_context programWithVertexShaderString:vertexShaderSource fragmentShaderString:fragmentShaderSource];
    _program = program;
}

- (void)p_setupTexture {
    UIImage *image = [UIImage imageNamed:@"IMG_3902.JPG"];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CVPixelBufferRef pixelBuffer = [image SMS_BGRAPixelBuffer];
    id<SMSGLTexture> texture = [_context makeBGRATextureWithPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
    _texture = texture;
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
    [_context asyncOnRenderingQueue:^{
        if (!self->_isPlaying) {
            return;
        }
        
        float currentFrame = CACurrentMediaTime();
        self->_deltaTime = currentFrame - self->_lastFrame;
        self->_lastFrame = currentFrame;
        
        [self->_context.device makeCurrent];
        
        glBindFramebuffer(GL_FRAMEBUFFER, self->_drawableFBOName);
        glViewport(0, 0, self->_drawableSize.width, self->_drawableSize.height);
        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        [self->_program use];

        glBindVertexArray(self->_VAO);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, self->_texture.name);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        GLint ourTextureLocation = glGetUniformLocation(self->_program.programHandle, "ourTexture");
        glUniform1i(ourTextureLocation, 0);
        
        simd_float3 cubePositions[] = {
            simd_make_float3( 0.0f,  0.0f,  0.0f),
            simd_make_float3( 2.0f,  5.0f, -15.0f),
            simd_make_float3(-1.5f, -2.2f, -2.5f),
            simd_make_float3(-3.8f, -2.0f, -12.3f),
            simd_make_float3( 2.4f, -0.4f, -3.5f),
            
            simd_make_float3(-1.7f,  3.0f, -7.5f),
            simd_make_float3( 1.3f, -2.0f, -2.5f),
            simd_make_float3( 1.5f,  2.0f, -2.5f),
            simd_make_float3( 1.5f,  0.2f, -1.5f),
            simd_make_float3(-1.3f,  1.0f, -1.5f),
        };
        
//        matrix_float4x4 model = matrix_identity_float4x4;
//        model = matrix_multiply(matrix4x4_rotation(CACurrentMediaTime() * radians_from_degrees(50), 1, 0, 0), model);
        
        matrix_float4x4 view = matrix_look_at_right_hand(self->_cameraPos, self->_cameraPos + self->_cameraFront, self->_cameraUp);
//        view = matrix_multiply(matrix4x4_translation(0, 0, -5), view);
        
        matrix_float4x4 projection;
        projection = matrix_perspective_right_hand(radians_from_degrees(45), self->_drawableSize.width / self->_drawableSize.height, 0.1, 100);
        
        GLint viewLocation = glGetUniformLocation(self->_program.programHandle, "view");
        glUniformMatrix4fv(viewLocation, 1, GL_FALSE, (GLfloat*)&view);
        
        GLint projectionLocation = glGetUniformLocation(self->_program.programHandle, "projection");
        glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, (GLfloat*)&projection);
        
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self->_EBO);
//        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
        
        glEnable(GL_DEPTH_TEST);
        
        for (int i = 0; i < 1; ++i) {
            matrix_float4x4 model = matrix_identity_float4x4;
            model = matrix_multiply(matrix4x4_translation(cubePositions[i]), model);
//            model = matrix_multiply(matrix4x4_rotation(radians_from_degrees(20.0 * i), simd_make_float3(1.0, 0.3, 0.5)), model);
            
            GLint modelLocation = glGetUniformLocation(self->_program.programHandle, "model");
            glUniformMatrix4fv(modelLocation, 1, GL_FALSE, (GLfloat*)&model);
            
            glDrawArrays(GL_TRIANGLES, 0, 36);
        }

        glBindVertexArray(0);
        
        glBindRenderbuffer(GL_RENDERBUFFER, self->_drawableColorRenderBuffer);
        [[self->_context.device eaglContext] presentRenderbuffer:GL_RENDERBUFFER];
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glDisable(GL_DEPTH_TEST);
    }];
}

- (void)play {
    _isPlaying = YES;
}

- (void)pause {
    _isPlaying = NO;
}

- (void)W {
    float speed = 2.5 * _deltaTime;
    _cameraPos += speed * _cameraFront;
}

- (void)A {
    float speed = 2.5 * _deltaTime;
    _cameraPos -= simd_normalize(simd_cross(_cameraFront, _cameraUp)) * speed;
}

- (void)S {
    float speed = 2.5 * _deltaTime;
    _cameraPos -= speed * _cameraFront;
}

- (void)D {
    float speed = 2.5 * _deltaTime;
    _cameraPos += simd_normalize(simd_cross(_cameraFront, _cameraUp)) * speed;
}

@end
