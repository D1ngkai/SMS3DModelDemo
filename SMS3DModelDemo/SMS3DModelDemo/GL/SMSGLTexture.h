//
//  SMSGLTexture.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/18.
//

#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SMSGLTextureSetupStatus) {
    SMSGLTextureSetupStatusSuccess,
    SMSGLTextureSetupStatusInvalidPixelBuffer,
    SMSGLTextureSetupStatusFailedToCreateTexture
};

@class SMSGLContext;

@protocol SMSGLTexture <NSObject>

/// Will Retain pixelBuffer
- (instancetype)initWithContext:(SMSGLContext *) context
                    pixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (SMSGLTextureSetupStatus)textureSetupStatus;

- (GLuint)name;
- (GLenum)target;

- (void)releaseResource;

@end

NS_ASSUME_NONNULL_END
