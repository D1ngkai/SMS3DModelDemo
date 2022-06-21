//
//  SMSGLProgram.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/16.
//

#import "SMSGLProgram.h"

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface SMSGLProgram () {
    @private
    NSString *_fragmentShaderString;
    NSString *_vertexShaderString;
    GLuint _programHandle;
}

@end

@implementation SMSGLProgram

- (instancetype)initWithVertexShaderString:(NSString *)vertexShaderString
                      fragmentShaderString:(NSString *)fragmentShaderString {
    self = [super init];
    if (self) {
        _vertexShaderString = [vertexShaderString copy];
        _fragmentShaderString = [fragmentShaderString copy];

        [self p_setupGLProgram];
    }

    return self;
}

- (void)p_setupGLProgram {
    GLuint vertexShader = [self p_loadGLShader:_vertexShaderString
                                    shaderType:GL_VERTEX_SHADER];
    if (vertexShader == 0) {
        return;
    }

    GLuint fragmentShader = [self p_loadGLShader:_fragmentShaderString
                                      shaderType:GL_FRAGMENT_SHADER];
    if (fragmentShader == 0) {
        return;
    }

    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    GLint success;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetProgramInfoLog(programHandle, 512, NULL, infoLog);
        NSCAssert(NO, @"Could not link program: %s", infoLog);
        glDeleteProgram(programHandle);
    }
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    _programHandle = programHandle;
}

- (GLuint)p_loadGLShader:(NSString *)shaderSource
              shaderType:(GLenum)shaderType {
    GLuint shader = glCreateShader(shaderType);
    const GLchar *source = (GLchar *)[shaderSource UTF8String];
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);

    GLint success;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[512];
        glGetShaderInfoLog(shader, 512, NULL, infoLog);
        NSCAssert(NO, @"Could not compile shader: %d %s", shaderType, infoLog);
        glDeleteShader(shader);
        shader = 0;
    }

    return shader;
}

- (int)programHandle {
    return (int)_programHandle;
}

- (void)use {
    glUseProgram(_programHandle);
}

- (void)deleteProgram {
    if (_programHandle) {
        glDeleteProgram(_programHandle);
        _programHandle = 0;
    }
}

- (int)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(_programHandle, [uniformName UTF8String]);
}

@end
