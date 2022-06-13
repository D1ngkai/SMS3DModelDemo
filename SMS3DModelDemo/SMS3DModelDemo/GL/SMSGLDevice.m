//
//  SMSGLDevice.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "SMSGLDevice.h"

@interface SMSGLDevice () {
    @private
    CVOpenGLESTextureCacheRef _textureCache;
    EAGLContext *_eaglContext;
}

@end

@implementation SMSGLDevice

- (instancetype)init {
    self = [super init];
    if (self) {
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    }
    return self;
}

- (EAGLContext *)eaglContext {
    return _eaglContext;
}

- (CVOpenGLESTextureCacheRef)textureCache {
    if (!_textureCache) {
        CFMutableDictionaryRef attrs = CFDictionaryCreateMutable(
                                                                 kCFAllocatorDefault,
                                                                 1,
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks
                                                                 );
        CFDictionarySetValue(attrs,
                             kCVOpenGLESTextureCacheMaximumTextureAgeKey,
                             (__bridge const void *)([NSNumber numberWithFloat:0]));
        CVOpenGLESTextureCacheCreate(
                                     kCFAllocatorDefault,
                                     attrs,
                                     _eaglContext,
                                     NULL,
                                     &_textureCache
                                     );
        CFRelease(attrs);
    }
    return _textureCache;
}

- (void)releaseTexture:(CVOpenGLESTextureRef)texture {
    if (texture == nil || _textureCache == nil) {
        return;
    }
    CFRelease(texture);
    CVOpenGLESTextureCacheFlush(_textureCache, 0);
}

@end
