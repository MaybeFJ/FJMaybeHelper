//
//  NSString+FJString.h
//  stringdemo
//
//  Created by 王飞 on 2017/1/9.
//  Copyright © 2017年 王飞. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,StringFormatterStyle){
    StringFormatterStyleNormal          = 1000, //yyyy-MM-dd HH:mm:ss
    StringFormatterStyleNormalNOSeconds = 1001, //yyyy-MM-dd HH:mm
    StringFormatterStyleNormalNOHours   = 1002, //yyyy-MM-dd
    StringFormatterStyleChina           = 1003, //yyyy:MM:dd HH:mm:ss
    StringFormatterStyleChinaNOSeconds  = 1004, //yyyy:MM:dd HH:mm
    StringFormatterStyleChinaNOHours    = 1005, //yyyy:MM:dd
    StringFormatterStyleOnlyHours       = 1006 //HH:mm
};
typedef NS_ENUM(NSInteger,PassWorldFormat){
    PassWorldFormatOnlyNumber                = 1000,//只允许数字
    PassWorldFormatOnlyCapitalAlphabet       = 1001,//只允许大写字母
    PassWorldFormatOnlyLowerAlphabet         = 1002,//只允许小写字母
    PassWorldFormatOnlyAlphabet              = 1003,//只允许字母
    PassWorldFormatNumberWithCapitalAlphabet = 1004,//只允许数字和大写字母
    PassWorldFormatNumberWithLowerAlphabet   = 1005,//只允许数字和小写字母
    PassWorldFormatNumberWithAlphabet        = 1006//两者都有
};
typedef NS_ENUM(NSInteger,RandominCludingStyle){
    RandominCludingStyleOnlyFront         = 1000,//举例:[100,200)
    RandominCludingStyleOnlyBehind        = 1001,//举例:(100,200]
    RandominCludingStyleFrontWithBehine   = 1002,//举例:[100,200]
    RandominCludingStyleNoFrontWithBehine = 1003 //举例:(100,200)
};
typedef struct _ValuesInterval{
    int StartNumber;//开始数字
    int EndNumber;  //结束数字
}ValuesInterval;

NS_INLINE ValuesInterval MakeValuesRange(int start, int end) {
    ValuesInterval range;
    range.StartNumber = start;
    range.EndNumber = end;
    return range;
}

@interface NSString (FJMString)

/**
 判断手机号是否正确
 
 @return 判断结果
 */
- (BOOL)isPhoneNumber;

/**
 隐藏手机号中间4位(如果不是手机号传入，将原样返回)

 @return 隐藏后的字符串
 */
- (nonnull NSString*)handlePhoneNumber;

/**
 区号格式化

 @return 返回格式化后的号码
 */
- (nonnull NSString*)areaNumberFormat;

/**
 判断是否是区号

 @return 判断结果
 */
- (BOOL)isAreaNumber;

/**
 密码是否符合规范

 @param pwdRange 密码长度要求
 @param formate  密码样式(默认数字和字母大写均有)
 @return 是否符合规范
 */
- (BOOL)pwdFormatRange:(NSRange)pwdRange formate:(PassWorldFormat)formate;

/**
 判断身份证号是否正确
 
 @return 判断结果
 */
- (BOOL)isIdCard;

/**
 判断护照是否正确
 
 @return 判断结果
 */
- (BOOL)isPassport;

/**
 判断是否是邮箱
 
 @return 判断结果
 */
- (BOOL)isEmail;

/**
 判断银行卡
 
 @return 判断结果
 */
- (BOOL)isBankCard;

/**
 隐藏银行号最后4位(如果不是银行卡号传入，将原样返回)

 @return 隐藏后的字符串
 */
- (nonnull NSString*)handleBankCard;

/**
 转换网址里面有汉字的字符串
 
 @return 转换汉字之后的字符串
 */
- (nonnull NSString*)formatChineseString;

/**
 移除字符串空格
 
 @return 返回移除空格的字符串
 */
- (nonnull NSString*)removeAllSpaceString;

/**
 移除字符串两边空格

 @return 返回移除空格的字符串
 */
- (nonnull NSString*)removeSpaceStringOnBothSides;

/**
 以字符分割字符串

 @param separatorStr 指定字符
 @return             分割之后的字符串数组
 */
- (nonnull NSArray *)splitString:(nullable NSString*)separatorStr;

/**
  转成时间(转化日期格式需与设定的日期格式一致，不然会导致转化失败)

 @param stringStyle 设定的日期格式
 @return            返回时间
 */
- (nonnull NSDate*)conversionTimeString:(StringFormatterStyle)stringStyle;

/**
 匹配字符串

 @param mactchStr 匹配的谓词
 @return          匹配结果
 */
- (BOOL)isMatching:(nonnull NSString*)mactchStr;

/**
 返回documents路径(去掉末尾空格)

 @return 路径字符串
 */
- (nonnull NSString*)documentsPath;

/**
 生成指定随机数字符串

 @param range 区间(例如500，600 指的是500到600之间)
 @param style 区间取值方式(默认RandominCludingStyleFrontWithBehine)
 @return  随机数字符串
 */
+(nonnull NSString*)genRandomString:(ValuesInterval)range style:(RandominCludingStyle)style;

/**
 设备标识
 
 @return 设备标示字符串(需打开xcode的capabilities的keychain sharing)
 */
+ (nonnull instancetype)IdentificationString;
@end
