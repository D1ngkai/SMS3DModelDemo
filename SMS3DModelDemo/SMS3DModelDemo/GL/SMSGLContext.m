//
//  SMSGLContext.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "SMSGLContext.h"

static void *SMSGLContextRenderingQueueKey;

@interface SMSGLContext () {
    @private
    dispatch_queue_t _renderingQueue;
}

@property (nonatomic) SMSGLDevice *device;

@property (nonatomic) NSMutableDictionary<NSString *, SMSGLProgram *> *programCache;

@property (nonatomic) SMSGLPixelBufferPool *pixelBufferPool;

@end

@implementation SMSGLContext

- (void)dealloc {
    [self flushProgramCache];
    [self flushTextureCache];
}

- (instancetype)initWithDevice:(SMSGLDevice *)device {
    self = [super init];
    if (self) {
        _device = device;

        // Rendering Queue
        SMSGLContextRenderingQueueKey = &SMSGLContextRenderingQueueKey;
        _renderingQueue = dispatch_queue_create("com.sms.renderingQueue",
                                                DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_renderingQueue,
                                    SMSGLContextRenderingQueueKey,
                                    (void *)SMSGLContextRenderingQueueKey,
                                    NULL);

        // Program Cache
        _programCache = @{}.mutableCopy;
        
        _pixelBufferPool = [[SMSGLPixelBufferPool alloc] init];
    }

    return self;
}

#pragma mark - Program
- (SMSGLProgram *)programWithVertexShaderString:(NSString *)vertexShaderString
                           fragmentShaderString:(NSString *)fragmentShaderString {
    __block SMSGLProgram *program;
    NSString *key = [self p_uniqueKeyWithVertexShaderString:vertexShaderString
                                       fragmentShaderString:fragmentShaderString];
    
    [self syncOnRenderingQueue:^{
        if (self.programCache[key]) {
            program = self.programCache[key];
        } else {
            [self.device makeCurrent];
            program = [[SMSGLProgram alloc] initWithVertexShaderString:vertexShaderString
                                                  fragmentShaderString:fragmentShaderString];
            self.programCache[key] = program;
        }
    }];

    return program;
}

/// FIXME: String compare operation costs too much.
- (NSString *)p_uniqueKeyWithVertexShaderString:(NSString *)vertexShaderString
                           fragmentShaderString:(NSString *)fragmentShaderString {
    NSString *str =[NSString stringWithFormat:@"v: %@, f: %@",
                    vertexShaderString,
                    fragmentShaderString];
    return str;
}

- (void)flushProgramCache {
    [self syncOnRenderingQueue:^{
        [self.device makeCurrent];
        [self.programCache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                               SMSGLProgram * _Nonnull obj,
                                                               BOOL * _Nonnull stop) {
            [obj deleteProgram];
        }];
        self.programCache = @{}.mutableCopy;
    }];
}

#pragma mark - Texture
- (id<SMSGLTexture>)makeBGRATextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    SMSGLBGRATexture *texture = [[SMSGLBGRATexture alloc] initWithContext:self pixelBuffer:pixelBuffer];
    return texture;
}

- (id<SMSGLTexture>)makeEmptyBGRATextureWithSize:(CGSize)size {
    CVPixelBufferRef pixelBuffer = [self.pixelBufferPool makeBGRAPixelBufferWithSize:size];
    SMSGLBGRATexture *texture = [[SMSGLBGRATexture alloc] initWithContext:self pixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
    return texture;
}

- (void)flushTextureCache {
    [self.pixelBufferPool flush];
    CVOpenGLESTextureCacheFlush([self.device textureCache], 0);
}

#pragma mark - Rendering Queue
- (void)asyncOnRenderingQueue:(dispatch_block_t)block {
    if (dispatch_get_specific(SMSGLContextRenderingQueueKey)) {
        block();
    } else {
        dispatch_async(_renderingQueue, block);
    }
}

- (void)syncOnRenderingQueue:(dispatch_block_t)block {
    if (dispatch_get_specific(SMSGLContextRenderingQueueKey)) {
        block();
    } else {
        dispatch_sync(_renderingQueue, block);
    }
}

@end
