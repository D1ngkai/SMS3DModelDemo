//
//  SMSGLBGRATexture.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/18.
//

#import "SMSGLBGRATexture.h"

#import "SMSGLContext.h"
#import "SMSGLDevice.h"

@interface SMSGLBGRATexture ()

@property (nonatomic) SMSGLContext *context;
@property (nonatomic) CVPixelBufferRef pixelBuffer;
@property (nonatomic) CVOpenGLESTextureRef texture;

@property (nonatomic) SMSGLTextureSetupStatus status;

@end

@implementation SMSGLBGRATexture

- (void)dealloc {
    [self releaseResource];
}

- (instancetype)initWithContext:(SMSGLContext *)context
                    pixelBuffer:(CVPixelBufferRef)pixelBuffer {
    self = [super init];
    if (self) {
        _status = SMSGLTextureSetupStatusSuccess;
        BOOL isBGRAPixelBuffer = CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA;
        if (!isBGRAPixelBuffer) {
            NSCAssert(NO, @"invalid pixelBuffer format: %d", CVPixelBufferGetPixelFormatType(pixelBuffer));
            _status = SMSGLTextureSetupStatusInvalidPixelBuffer;
            return self;
        }
        
        
        _context = context;
        _pixelBuffer = pixelBuffer;
        
        CVPixelBufferRetain(pixelBuffer);
        
        int width = (int)CVPixelBufferGetWidth(pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                     [context.device textureCache],
                                                     pixelBuffer,
                                                     NULL,
                                                     GL_TEXTURE_2D,
                                                     GL_RGBA,
                                                     width,
                                                     height,
                                                     GL_BGRA,
                                                     GL_UNSIGNED_BYTE,
                                                     0,
                                                     &_texture);
        CVReturn err = 0;
        if (err) {
            NSCAssert(NO, @"CVOpenGLESTextureCacheCreateTextureFromImage Error: %d", err);
            _status = SMSGLTextureSetupStatusFailedToCreateTexture;
        }
    }
    
    return self;
}

- (SMSGLTextureSetupStatus)textureSetupStatus {
    return _status;
}

- (GLuint)name {
    if (!_texture) {
        return -1;
    }
    
    return CVOpenGLESTextureGetName(_texture);
}

- (GLenum)target {
    if (!_texture) {
        return -1;
    }
    
    return CVOpenGLESTextureGetTarget(_texture);
}

- (int)width {
    return (int)CVPixelBufferGetWidth(_pixelBuffer);
}


- (int)height {
    return (int)CVPixelBufferGetHeight(_pixelBuffer);
}

- (void)releaseResource {
    if (_texture) {
        CFRelease(_texture);
        _texture = NULL;
        CVOpenGLESTextureCacheFlush([_context.device textureCache], 0);
    }
    
    if (_pixelBuffer) {
        CVPixelBufferRelease(_pixelBuffer);
        _pixelBuffer = NULL;
    }
}

@end
