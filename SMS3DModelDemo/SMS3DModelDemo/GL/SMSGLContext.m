//
//  SMSGLContext.m
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import "SMSGLContext.h"

@interface SMSGLContext ()

@property (nonatomic) SMSGLDevice *device;

@end

@implementation SMSGLContext

- (instancetype)initWithDevice:(SMSGLDevice *)device {
    self = [super init];
    if (self) {
        _device = device;
    }

    return self;
}

@end
