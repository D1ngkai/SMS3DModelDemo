//
//  SMSGLPixelBufferPool.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/18.
//

#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSGLPixelBufferPool : NSObject

- (CVPixelBufferRef)makePixelBufferWithSize:(CGSize)size
                                     format:(OSType)format;

- (CVPixelBufferRef)makeBGRAPixelBufferWithSize:(CGSize)size;

- (void)flush;

@end

NS_ASSUME_NONNULL_END
