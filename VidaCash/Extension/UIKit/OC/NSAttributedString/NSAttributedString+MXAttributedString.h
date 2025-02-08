//
//  NSAttributedString+MXAttributedString.h
//  MXCash
//
//  Created by Yu Chen  on 2025/1/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (MXAttributedString)

+ (NSMutableAttributedString *)attachmentImage:(NSString *)imageName afterText:(BOOL)after imagePosition:(CGFloat)y attributeString:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)font;
+ (NSMutableAttributedString *)attachmentImageWithUnderLine:(NSString *)imageName afterText:(BOOL)after imagePosition:(CGFloat)y attributeString:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)font;
+ (NSMutableAttributedString *)attributeText1:(NSString *)text1 text1Color:(UIColor *)color1 text1Font:(UIFont *)font1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text1Font:(UIFont *)font2 paramDistance:(CGFloat)distance paraAlign:(NSTextAlignment)align;

@end

NS_ASSUME_NONNULL_END
