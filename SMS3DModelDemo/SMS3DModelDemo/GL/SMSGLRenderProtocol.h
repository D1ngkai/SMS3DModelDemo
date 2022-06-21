//
//  SMSGLRenderProtocol.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import <Foundation/Foundation.h>

#import "SMSGLTexture.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SMSGLRenderProtocol <NSObject>

@optional
- (void)drawTexture:(id<SMSGLTexture>)texture
           onCanvas:(id<SMSGLTexture>)canvas;

- (void)drawTexture0:(id<SMSGLTexture>)texture0
            texture1:(id<SMSGLTexture>)texture1
           onCanvas:(id<SMSGLTexture>)canvas;

@end

NS_ASSUME_NONNULL_END
