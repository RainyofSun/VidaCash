//
//  UIView+VCAPPUIViewExtension.h
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 抖动方向
///
/// - horizontal: 水平抖动
/// - vertical:   垂直抖动
typedef enum : NSUInteger {
    horizontal,
    vertical,
} ShakeDirection;

@interface UIView (VCAPPUIViewExtension)

/// 扩展UIView增加抖动方法
///
/// - Parameters:
///   - direction:  抖动方向    默认水平方向
///   - times:      抖动次数    默认5次
///   - interval:   每次抖动时间 默认0.1秒
///   - offset:     抖动的偏移量 默认2个点
///   - completion: 抖动结束回调
- (void)shakeAnimation:(ShakeDirection)direction repeatCount:(NSInteger)count anmationTime:(CGFloat)time offset:(CGFloat)offset completion: (void(^)(void))complete;

/// 切割部分圆角
- (void)cutViewRoundingCorners:(UIRectCorner)corners radius:(CGFloat)ragius;
/// 切割部分圆角指定宽度
- (void)cutViewRoundingCorners:(UIRectCorner)corners viewWidth:(CGFloat)width radius:(CGFloat)ragius;

@end

NS_ASSUME_NONNULL_END
