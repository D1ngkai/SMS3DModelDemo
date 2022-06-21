//
//  SMSGLFilter.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import "SMSGLFilter.h"

#import "SMSGLProgram.h"

@interface SMSGLFilter ()

@property (nonatomic) SMSGLProgram *program;
@property (nonatomic) SMSGLContext *context;

@end

@implementation SMSGLFilter

- (instancetype)initWithProgram:(SMSGLProgram *)program
                        context:(SMSGLContext *)context {
    self = [super init];
    if (self) {
        _program = program;
        _context = context;
    }

    return self;
}

- (void)drawTexture:(id<SMSGLTexture>)texture
           onCanvas:(id<SMSGLTexture>)canvas {
    [self.program use];

    static const GLfloat position[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat inputFragCoord[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };

    int width = [canvas width];
    int height = [canvas height];
    GLuint fbo = 0;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glViewport(0, 0, width, height);
    glFramebufferTexture2D(GL_FRAMEBUFFER,
                           GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D,
                           [canvas name],
                           0);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0,
                          2,
                          GL_FLOAT,
                          0,
                          0,
                          position);

    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1,
                          2,
                          GL_FLOAT,
                          0,
                          0,
                          inputFragCoord);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, [texture name]);
    glUniform1i([self.program uniformIndex:@"iChannel0"], 1);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MIN_FILTER,
                    GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MAG_FILTER,
                    GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_S,
                    GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_T,
                    GL_CLAMP_TO_EDGE);

    glUniform2f([self.program uniformIndex:@"iResolution"], [canvas width], [canvas height]);
    glUniform2f([self.program uniformIndex:@"iChannelResolution0"], [texture width], [texture height]);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    glDeleteFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)drawTexture0:(id<SMSGLTexture>)texture0
            texture1:(id<SMSGLTexture>)texture1
            onCanvas:(id<SMSGLTexture>)canvas {
    [self.program use];

    static const GLfloat position[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    static const GLfloat inputFragCoord[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };

    int width = [canvas width];
    int height = [canvas height];
    GLuint fbo = 0;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glViewport(0, 0, width, height);
    glFramebufferTexture2D(GL_FRAMEBUFFER,
                           GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D,
                           [canvas name],
                           0);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0,
                          2,
                          GL_FLOAT,
                          0,
                          0,
                          position);

    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1,
                          2,
                          GL_FLOAT,
                          0,
                          0,
                          inputFragCoord);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, [texture0 name]);
    glUniform1i([self.program uniformIndex:@"iChannel0"], 1);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MIN_FILTER,
                    GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MAG_FILTER,
                    GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_S,
                    GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_T,
                    GL_CLAMP_TO_EDGE);

    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [texture1 name]);
    glUniform1i([self.program uniformIndex:@"iChannel1"], 2);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MIN_FILTER,
                    GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MAG_FILTER,
                    GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_S,
                    GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D,
                    GL_TEXTURE_WRAP_T,
                    GL_CLAMP_TO_EDGE);

    glUniform2f([self.program uniformIndex:@"iChannelResolution0"], [texture0 width], [texture0 height]);
    glUniform2f([self.program uniformIndex:@"iChannelResolution1"], [texture1 width], [texture1 height]);
    glUniform2f([self.program uniformIndex:@"iResolution"], [canvas width], [canvas height]);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    glDeleteFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

@end
