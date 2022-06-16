//
//  SMSGLContext.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "SMSGLContext.h"

#import "SMSGLProgram.h"
#import "SMSGLDevice.h"

static void *SMSGLContextRenderingQueueKey;

@interface SMSGLContext () {
    @private
    dispatch_queue_t _renderingQueue;
}

@property (nonatomic) SMSGLDevice *device;

@property (nonatomic) NSMutableDictionary<NSString *, SMSGLProgram *> *programCache;

@end

@implementation SMSGLContext

- (void)dealloc {
}

- (instancetype)initWithDevice:(SMSGLDevice *)device {
    self = [super init];
    if (self) {
        _device = device;

        // Rendering Queue
        SMSGLContextRenderingQueueKey = &SMSGLContextRenderingQueueKey;
        _renderingQueue = dispatch_queue_create("com.sms.renderingQueue",
                                                NULL);
        dispatch_queue_set_specific(_renderingQueue,
                                    SMSGLContextRenderingQueueKey,
                                    (void *)SMSGLContextRenderingQueueKey,
                                    NULL);

        // Program Cache
        _programCache = @{}.mutableCopy;
    }

    return self;
}

- (void)releaseContext {
    [self syncOnRenderingQueue:^{
        [self.device makeCurrent];
        [self.programCache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SMSGLProgram * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj deleteProgram];
        }];
    }];
}

- (SMSGLProgram *)programWithVertexShaderString:(NSString *)vertexShaderString
                           fragmentShaderString:(NSString *)fragmentShaderString {
    __block SMSGLProgram *program;
    NSString *key = [self p_uniqueKeyWithVertexShaderString:vertexShaderString fragmentShaderString:fragmentShaderString];
    if (self.programCache[key]) {
        program = self.programCache[key];
    } else {
        [self syncOnRenderingQueue:^{
            [self.device makeCurrent];
            program = [[SMSGLProgram alloc] initWithVertexShaderString:vertexShaderString fragmentShaderString:fragmentShaderString];
            self.programCache[key] = program;
        }];
    }

    return program;
}

- (NSString *)p_uniqueKeyWithVertexShaderString:(NSString *)vertexShaderString
                           fragmentShaderString:(NSString *)fragmentShaderString {
    NSString *str =[NSString stringWithFormat:@"v: %@, f: %@",
                    vertexShaderString,
                    fragmentShaderString];
    return str;
}

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
