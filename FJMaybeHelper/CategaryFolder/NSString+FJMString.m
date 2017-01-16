//
//  NSString+FJString.m
//  stringdemo
//
//  Created by 王飞 on 2017/1/9.
//  Copyright © 2017年 王飞. All rights reserved.
//
#import "NSString+FJMString.h"
@implementation NSString (FJMString)
#pragma mark 手机号
- (BOOL)isPhoneNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 (147 178)
     * 联通：130,131,132,152,155,156,185,186 (145 176)
     * 电信：133,1349,153,180,189 (177 181)
     * 虚拟：170
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0125-9])\\d{8}$";;
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:self] == YES){
        return YES;
    }
    else{
        return NO;
    }
}

- (NSString*)handlePhoneNumber{
    if ([self isPhoneNumber]) {
        //替换某一位置的字符
        NSString *handleStr = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return handleStr;
    }
    return self;
}

#pragma mark 格式化区号
- (NSString*)areaNumberFormat{
    // 先去掉两边空格
    NSMutableString *value = [NSMutableString stringWithString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    // 先匹配是否有连字符/空格，如果有则直接返回
    NSString *regex = @"^0\\d{2,3}[- ]\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if([predicate evaluateWithObject:value]){
        // 替换掉中间的空格
        return [value stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    }
    // 格式化号码 三位区号
    regex = [NSString stringWithFormat:@"^(%@)\\d{7,8}$",[self regex_areaCode_threeDigit]];
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if([predicate evaluateWithObject:value]){
        // 插入连字符 "-"
        [value insertString:@"-" atIndex:3];
        return value;
    }
    // 格式化号码 四位区号
    regex = [NSString stringWithFormat:@"^(%@)\\d{7,8}$",[self regex_areaCode_fourDigit]];
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if([predicate evaluateWithObject:value]){
        // 插入连字符 "-"
        [value insertString:@"-" atIndex:4];
        return value;
    }
    return self;
}

- (NSString*)regex_areaCode_threeDigit
{
    return @"010|02[0-57-9]";
}

- (NSString*)regex_areaCode_fourDigit
{
    // 03xx
    NSString *fourDigit03 = @"03([157]\\d|35|49|9[1-68])";
    // 04xx
    NSString *fourDigit04 = @"04([17]\\d|2[179]|[3,5][1-9]|4[08]|6[4789]|8[23])";
    // 05xx
    NSString *fourDigit05 = @"05([1357]\\d|2[37]|4[36]|6[1-6]|80|9[1-9])";
    // 06xx
    NSString *fourDigit06 = @"06(3[1-5]|6[0238]|9[12])";
    // 07xx
    NSString *fourDigit07 = @"07(01|[13579]\\d|2[248]|4[3-6]|6[023689])";
    // 08xx
    NSString *fourDigit08 = @"08(1[23678]|2[567]|[37]\\d|5[1-9]|8[3678]|9[1-8])";
    // 09xx
    NSString *fourDigit09 = @"09(0[123689]|[17][0-79]|[39]\\d|4[13]|5[1-5])";
    return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",fourDigit03,fourDigit04,fourDigit05,fourDigit06,fourDigit07,fourDigit08,fourDigit09];
}

- (BOOL)isAreaNumber{
    NSString *regex = [NSString stringWithFormat:@"^(%@)|(%@)\\d{7,8}$",[self regex_areaCode_threeDigit],[self regex_areaCode_fourDigit]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if([predicate evaluateWithObject:self]){
        return YES;
    }
    return NO;
}

#pragma mark 密码是否合理判断
- (BOOL)pwdFormatRange:(NSRange)pwdRange formate:(PassWorldFormat)formate{
    NSString* pwdFormatStr;
    switch (formate) {
        case PassWorldFormatOnlyNumber:
            pwdFormatStr = [NSString stringWithFormat:@"[0-9]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatOnlyCapitalAlphabet:
            pwdFormatStr = [NSString stringWithFormat:@"[A-Z]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatOnlyLowerAlphabet:
            pwdFormatStr = [NSString stringWithFormat:@"[a-z]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatOnlyAlphabet:
              pwdFormatStr = [NSString stringWithFormat:@"[a-zA-Z]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatNumberWithCapitalAlphabet:
            pwdFormatStr = [NSString stringWithFormat:@"[A-Z0-9]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatNumberWithLowerAlphabet:
            pwdFormatStr = [NSString stringWithFormat:@"[a-z0-9]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        case PassWorldFormatNumberWithAlphabet:
              pwdFormatStr = [NSString stringWithFormat:@"[a-zA-Z0-9]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
        default:
            pwdFormatStr = [NSString stringWithFormat:@"[a-zA-Z0-9]{%lu,%lu}",(unsigned long)pwdRange.location,pwdRange.location + pwdRange.length];
            break;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdFormatStr];
    return [pred evaluateWithObject:self];
}

#pragma mark 验证身份证号
- (BOOL)isIdCard{
    if (self.length==0) {
        return NO;
    }
    if (!(self.length==15 || self.length==18)) {
        return NO;
    }
    NSUInteger len=self.length;
    unichar chs[len];
    [self getCharacters:chs];
    for (int i=0; i<len; i++) {
        if (!((chs[i]>='0' && chs[i]<='9')||(i==17 && chs[i]=='X')) ) {
            return NO;
        }
    }
    NSString* strBirth;
    if (len==15) {
        strBirth=[NSString stringWithFormat:@"19%@",[self substringWithRange:NSMakeRange(6, 6)]];
    }
    else{
        strBirth=[self substringWithRange:NSMakeRange(6, 8)];
    }
    NSDateFormatter* fmt=[NSDateFormatter new];
    fmt.dateFormat=@"yyyyMMdd";
    NSDate* birth=[fmt dateFromString:strBirth];
    if (birth==nil) {
        return NO;
    }
    if (len==15) {
        return YES;
    }
    int sum=0;
    int code[]={2,4,8,5,10,9,7,3,6,1,2,4,8,5,10,9,7};
    for (int i=0; i<17; i++) {
        sum+=code[i]*(chs[16-i]-'0');
    }
    int r=sum%11;
    NSString* strTail=@"10X98765432";
    unichar chCode=[strTail characterAtIndex:r];
    if (chCode==chs[17]) {
        return YES;
    }
    return NO;
}

#pragma mark 判断护照
- (BOOL)isPassport{
    const char *str = [self UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G' ||first == 'D' ||first == 'S' || first == 'E'))
    {
        return NO;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return NO;
        }
    }
    if (first == 'E')
    {
        if (length != 9)
        {
            return NO;
        }
    }
    if (first == 'S')
    {
        if (length != 9)
        {
            return NO;
        }
    }
    if (first == 'D')
    {
        if (length != 9)
        {
            return NO;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return NO;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = NO;
            break;
        }
    }
    return result;
}

#pragma mark 判断邮箱
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark 判断银行卡号
- (BOOL)isBankCard{
    NSString* cardNumber = self;
    int oddSum = 0;     // 奇数和
    int evenSum = 0;    // 偶数和
    int allSum = 0;     // 总和
    // 循环加和
    for (NSInteger i = 1; i <= cardNumber.length; i++)
    {
        NSString *theNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length-i, 1)];
        int lastNumber = [theNumber intValue];
        if (i%2 == 0)
        {
            // 偶数位
            lastNumber *= 2;
            if (lastNumber > 9)
            {
                lastNumber -=9;
            }
            evenSum += lastNumber;
        }
        else
        {
            // 奇数位
            oddSum += lastNumber;
        }
    }
    allSum = oddSum + evenSum;
    // 是否合法
    if (allSum%10 == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString*)handleBankCard{
    if ([self isBankCard]) {
        NSString* bankCardStr = [self substringFromIndex:self.length - 4];
        return [NSString stringWithFormat:@"**** **** **** %@",bankCardStr];
    }
    return self;
}

#pragma mark 转换中文字符
- (NSString*)formatChineseString{
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    return  [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
#else
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
#endif
}

#pragma mark 移除空格
- (NSString*)removeAllSpaceString{
     return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)removeSpaceStringOnBothSides{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark 以字符形式分割字符串
- (NSArray*)splitString:(NSString *)separatorStr{
    if (separatorStr == nil) {
        return @[self];
    }
    NSArray *strArr = [self componentsSeparatedByString:separatorStr];
    return strArr;
}

#pragma mark 匹配字符串
- (BOOL)isMatching:(NSString *)mactchStr{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mactchStr];
    return [pred evaluateWithObject:self];
}

#pragma mark 字符串转date
- (NSDate*)conversionTimeString:(StringFormatterStyle)stringStyle{
    return [[self makeFormatter:stringStyle] dateFromString:self];
}

- (NSDateFormatter*)makeFormatter:(StringFormatterStyle)stringStyle{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    switch (stringStyle) {
        case StringFormatterStyleNormal:
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
        case StringFormatterStyleNormalNOSeconds:
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            break;
        case StringFormatterStyleNormalNOHours:
            formatter.dateFormat = @"yyyy-MM-dd";
            break;
        case StringFormatterStyleChina:
            formatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
        case StringFormatterStyleChinaNOSeconds:
            formatter.dateFormat = @"yyyy:MM:dd HH:mm";
            break;
        case StringFormatterStyleChinaNOHours:
            formatter.dateFormat = @"yyyy:MM:dd";
            break;
        case StringFormatterStyleOnlyHours:
            formatter.dateFormat = @"HH:mm";
        default:
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
    }
    return formatter;
}

#pragma mark 路径
- (NSString*)documentsPath{
     NSString* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     NSString* appendString = [path removeSpaceStringOnBothSides];
     return  appendString;
}

#pragma mark 随机数生成
+ (NSString*)genRandomString:(ValuesInterval)range style:(RandominCludingStyle)style{
    NSInteger begin = range.StartNumber;
    NSInteger end = range.EndNumber;
    NSInteger arcdom;
    switch (style) {
        case RandominCludingStyleOnlyFront:
            arcdom = begin + (arc4random() % (end - begin));
            break;
        case RandominCludingStyleOnlyBehind:
            arcdom = begin + (arc4random() % (end - begin)) + 1;
            break;
        case RandominCludingStyleFrontWithBehine:
            arcdom = begin + (arc4random() % (end - begin + 1));
            break;
        case RandominCludingStyleNoFrontWithBehine:
            arcdom = begin + ((arc4random() % (end - begin - 1)) + 1);
            break;
        default:
            arcdom = begin + (arc4random() % (end - begin + 1));
            break;
    }
    NSString* str = [NSString stringWithFormat:@"%ld",arcdom];
    return str;
}

#pragma mark 获取设备标识符
+ (instancetype)IdentificationString{
    NSString * strUUID = (NSString *)[self load:@"com.company.app.usernamepassword"];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        uuidRef=nil;
        //将该uuid保存到keychain
        [self save:@"com.company.app.usernamepassword" data:strUUID];
    }
    return strUUID;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
@end
