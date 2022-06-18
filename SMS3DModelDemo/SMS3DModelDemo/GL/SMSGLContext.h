//
//  SMSGLContext.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import <Foundation/Foundation.h>

#import "SMSGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@class SMSGLDevice, SMSGLProgram;

@interface SMSGLContext : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDevice:(SMSGLDevice *)device;

@property (nonatomic, readonly) SMSGLDevice *device;


- (BOOL)makeCurrent;

#pragma mark - Program
- (SMSGLProgram *)programWithVertexShaderString:(NSString *)vertexShaderString
                           fragmentShaderString:(NSString *)fragmentShaderString;

- (void)flushProgramCache;

#pragma mark - Texture
- (id<SMSGLTexture>)makeBGRATextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (id<SMSGLTexture>)makeEmptyBGRATextureWithSize:(CGSize)size;

- (void)flushTextureCache;

#pragma mark - Rendering Queue
- (void)asyncOnRenderingQueue:(dispatch_block_t)block;
- (void)syncOnRenderingQueue:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
