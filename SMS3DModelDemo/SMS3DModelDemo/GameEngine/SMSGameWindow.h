//
//  SMSGameWindow.h
//  SMS3DModelDemo
//
//  Created by lidingkai on 2022/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSGameWindow : UIView

@property (nonatomic, readonly) BOOL isPlaying;

- (void)play;

- (void)pause;

- (void)W;
- (void)A;
- (void)S;
- (void)D;

@end

NS_ASSUME_NONNULL_END
