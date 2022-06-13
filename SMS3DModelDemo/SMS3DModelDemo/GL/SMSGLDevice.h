//
//  SMSGLDevice.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSGLDevice : NSObject

- (EAGLContext *)eaglContext;

- (CVOpenGLESTextureCacheRef)textureCache;

- (void)releaseTexture:(CVOpenGLESTextureRef)texture;

@end

NS_ASSUME_NONNULL_END
