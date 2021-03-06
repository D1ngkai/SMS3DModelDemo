//
//  SMSGLProgram.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSGLProgram : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithVertexShaderString:(NSString *)vertexShaderString
                      fragmentShaderString:(NSString *)fragmentShaderString;

- (int)programHandle;

- (void)use;

- (void)deleteProgram;

- (int)uniformIndex:(NSString *)uniformName;

@end

NS_ASSUME_NONNULL_END
