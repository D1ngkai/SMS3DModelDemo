//
//  SMSGameEngine.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMSGameWindow;

@interface SMSGameEngine : NSObject

- (void)bindEAGLDrawable:(id<EAGLDrawable>)drawable;
- (void)updateEAGLDrawableSize;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
