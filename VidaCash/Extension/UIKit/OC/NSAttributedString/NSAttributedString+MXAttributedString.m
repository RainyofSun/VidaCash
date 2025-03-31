//
//  NSAttributedString+MXAttributedString.m
//  MXCash
//
//  Created by Yu Chen  on 2025/1/4.
//

#import "NSAttributedString+MXAttributedString.h"
#import "NSString+VCAPPStringExtension.h"
#import <YYKit/UIColor+YYAdd.h>

@implementation NSAttributedString (MXAttributedString)

+ (NSMutableAttributedString *)attachmentImage:(NSString *)imageName afterText:(BOOL)after imagePosition:(CGFloat)y attributeString:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)font {
    UIImage *img = [UIImage imageNamed:imageName];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = img;
    attachment.bounds = CGRectMake(0, y, img.size.width, img.size.height);
    
    NSString *tempStr = after ? [NSString stringWithFormat:@"%@ ", str] : [NSString stringWithFormat:@" %@", str];
    NSMutableAttributedString *tempAttribute = [[NSMutableAttributedString alloc] initWithString:tempStr attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font}];
    if (after) {
        [tempAttribute appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    } else {
        [tempAttribute insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    }
    
    if ([str isEqualToString:@"mmmmm"]) {
        [tempAttribute appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    
    return tempAttribute;
}

+ (NSMutableAttributedString *)attachmentImageWithUnderLine:(NSString *)imageName afterText:(BOOL)after imagePosition:(CGFloat)y attributeString:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)font {
    if ([NSString isEmpty:str]) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    UIImage *img = [UIImage imageNamed:imageName];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = img;
    attachment.bounds = CGRectMake(0, y, img.size.width, img.size.height);
    
    NSString *tempStr = after ? [NSString stringWithFormat:@"%@ ", str] : [NSString stringWithFormat:@" %@", str];
    NSMutableAttributedString *tempAttribute = [[NSMutableAttributedString alloc] initWithString:tempStr attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font, NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName: [UIColor colorWithHexString:@"#2C65FE"]}];
    if (after) {
        [tempAttribute appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    } else {
        [tempAttribute insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    }
    
    if ([str isEqualToString:@"Nice"]) {
        [tempAttribute appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    
    return tempAttribute;
}

+ (NSMutableAttributedString *)attributeText1:(NSString *)text1 text1Color:(UIColor *)color1 text1Font:(UIFont *)font1 text2:(NSString *)text2 text2Color:(UIColor *)color2 text1Font:(UIFont *)font2 paramDistance:(CGFloat)distance paraAlign:(NSTextAlignment)align {
    
    if ([NSString isEmpty:text1] || [NSString isEmpty:text2]) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: color1, NSFontAttributeName: font1}];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: color2, NSFontAttributeName: font2}];
    
    if (distance >= 0) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = align;
        style.paragraphSpacing = distance;
        
        [dict1 setValue:style forKey:NSParagraphStyleAttributeName];
        [dict2 setValue:style forKey:NSParagraphStyleAttributeName];
    }
    
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", text1] attributes:dict1];
    [tempStr appendAttributedString:[[NSAttributedString alloc] initWithString:text2 attributes:dict2]];
    
    if ([text1 isEqualToString:@"Nice"]) {
        [tempStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}]];
    }
    
    return tempStr;
}

@end
