//
//  SMSGLContext.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SMSGLDevice;

@interface SMSGLContext : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDevice:(SMSGLDevice *)device;

@property (nonatomic, readonly) SMSGLDevice *device;

@end

NS_ASSUME_NONNULL_END
