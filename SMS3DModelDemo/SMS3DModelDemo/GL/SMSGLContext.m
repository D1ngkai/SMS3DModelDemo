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

@end

@implementation SMSGLContext

- (void)dealloc {
}

- (instancetype)initWithDevice:(SMSGLDevice *)device {
    self = [super init];
    if (self) {
        _device = device;

        SMSGLContextRenderingQueueKey = &SMSGLContextRenderingQueueKey;
        _renderingQueue = dispatch_queue_create("com.sms.renderingQueue",
                                                NULL);
        dispatch_queue_set_specific(_renderingQueue,
                                    SMSGLContextRenderingQueueKey,
                                    (void *)SMSGLContextRenderingQueueKey,
                                    NULL);
    }

    return self;
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
