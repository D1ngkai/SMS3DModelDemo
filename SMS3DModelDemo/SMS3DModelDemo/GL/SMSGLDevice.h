//
//  SMSGLDevice.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSGLDevice : NSObject

#pragma mark - EAGLContext

- (EAGLContext *)eaglContext;

- (BOOL)makeCurrent;

#pragma mark - Texture

- (CVOpenGLESTextureCacheRef)textureCache;

@end

NS_ASSUME_NONNULL_END
