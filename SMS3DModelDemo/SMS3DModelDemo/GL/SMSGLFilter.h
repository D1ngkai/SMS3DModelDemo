//
//  SMSGLFilter.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import <Foundation/Foundation.h>

#import "SMSGLRenderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SMSGLProgram;

@interface SMSGLFilter : NSObject <SMSGLRenderProtocol>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithProgram:(SMSGLProgram *)program
                        context:(SMSGLContext *)context;

@end

NS_ASSUME_NONNULL_END
