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

- (void)drawTexture:(NSArray<id<SMSGLTexture>> *)textures
           onCanvas:(id<SMSGLTexture>)canvas;

@end

NS_ASSUME_NONNULL_END
