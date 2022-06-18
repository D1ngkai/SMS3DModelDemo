//
//  SMSGLPixelBufferPool.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/18.
//

#import "SMSGLPixelBufferPool.h"

@interface SMSGLPixelBufferPool () {
    @private
    NSMutableDictionary *_poolCache;
}

@end

@implementation SMSGLPixelBufferPool

- (void)dealloc {
    [self flush];
    
    for (NSString *key in _poolCache.allKeys) {
        CVPixelBufferPoolRef poolRef = (__bridge CVPixelBufferPoolRef)(_poolCache[key]);
        CVPixelBufferPoolRelease(poolRef);
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _poolCache = @{}.mutableCopy;
    }
    return self;
}

- (CVPixelBufferRef)makePixelBufferWithSize:(CGSize)size
                                     format:(OSType)format {
    NSString *poolKey = [NSString stringWithFormat:@"%i, %i, %i", format, (int)size.width, (int)size.height];
    CVPixelBufferPoolRef poolRef = (__bridge CVPixelBufferPoolRef)_poolCache[poolKey];
    if (!poolRef) {
        NSDictionary *poolAttributes = @{
            (__bridge NSString *)kCVPixelBufferPoolMinimumBufferCountKey: @(0),
            (__bridge NSString *)kCVPixelBufferPoolMaximumBufferAgeKey: @(0.1),
        };
        NSDictionary *pixelBufferAttributes = @{
            (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(format),
            (__bridge NSString *)kCVPixelBufferWidthKey: @(size.width),
            (__bridge NSString *)kCVPixelBufferHeightKey: @(size.height),
            (__bridge NSString *)kCVPixelBufferIOSurfacePropertiesKey: @{},
            (__bridge NSString *)kCVPixelBufferOpenGLESCompatibilityKey: @(YES),
        };
        CVReturn err = CVPixelBufferPoolCreate(kCFAllocatorDefault,
                                               (__bridge CFDictionaryRef)poolAttributes,
                                               (__bridge CFDictionaryRef)pixelBufferAttributes,
                                               &poolRef);
        if (err != kCVReturnSuccess) {
            NSLog(@"Create PixelBuffer Pool Failed");
            return NULL;
        }
        _poolCache[poolKey] = (__bridge id)poolRef;
    }
    CVPixelBufferRef pixelBuffer;
    CVReturn err = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, poolRef, &pixelBuffer);
    if (err != kCVReturnSuccess) {
        NSLog(@"Create PixelBuffer Failed");
    }
    return pixelBuffer;
}

- (CVPixelBufferRef)makeBGRAPixelBufferWithSize:(CGSize)size {
    return [self makePixelBufferWithSize:size format:kCVPixelFormatType_32BGRA];
}

- (void)flush {
    for (NSString *key in _poolCache.allKeys) {
        CVPixelBufferPoolRef poolRef = (__bridge CVPixelBufferPoolRef)(_poolCache[key]);
        CVPixelBufferPoolFlush(poolRef, kCVPixelBufferPoolFlushExcessBuffers);
    }
}

@end
