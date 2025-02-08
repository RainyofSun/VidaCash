//
//  UIView+VCAPPUIViewExtension.m
//  VidaCash
//
//  Created by Yu Chen  on 2025/1/31.
//

#import "UIView+VCAPPUIViewExtension.h"

@implementation UIView (VCAPPUIViewExtension)

- (void)shakeAnimation:(ShakeDirection)direction repeatCount:(NSInteger)count anmationTime:(CGFloat)time offset:(CGFloat)offset completion:(void (^)(void))complete {
    CGAffineTransform firstTrans, secondTrans;
    if (direction == horizontal) {
        firstTrans = CGAffineTransformMakeTranslation(offset, 0);
        secondTrans = CGAffineTransformMakeTranslation(-offset, 0);
    } else {
        firstTrans = CGAffineTransformMakeTranslation(0, offset);
        secondTrans = CGAffineTransformMakeTranslation(0, -offset);
    }
    
    self.transform = firstTrans;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        [UIView setAnimationRepeatCount:count];
        self.transform = secondTrans;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time animations:^{
            [self.layer setAffineTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            complete();
        }];
    }];
}

- (void)cutViewRoundingCorners:(UIRectCorner)corners viewWidth:(CGFloat)width radius:(CGFloat)ragius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, CGRectGetHeight(self.bounds)) byRoundingCorners:corners cornerRadii:CGSizeMake(ragius, ragius)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
}

- (void)cutViewRoundingCorners:(UIRectCorner)corners radius:(CGFloat)ragius{
    [self cutViewRoundingCorners:corners viewWidth:CGRectGetWidth(self.bounds) radius:ragius];
}

@end
