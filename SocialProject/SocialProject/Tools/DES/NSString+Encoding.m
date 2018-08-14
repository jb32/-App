//
//  NSString+Encoding.m
//  LYFootballLottery
//
//  Created by Tsz on 2017/1/11.
//  Copyright © 2017年 Tsz. All rights reserved.
//

#import "NSString+Encoding.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation NSString (DESEncoding)

- (nonnull NSString *)encodingWithDESKey:(nonnull NSString *)desKey {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSData *keyData = [desKey dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    CCCryptorRef thisEncipher = NULL;
    uint8_t iv[kCCBlockSizeDES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    CCCryptorStatus ccStatus = CCCryptorCreate(kCCEncrypt,
                                               kCCAlgorithmDES,
                                               kCCOptionPKCS7Padding | kCCOptionECBMode,
                                               (const void *)[keyData bytes],
                                               kCCBlockSizeDES,
                                               (const void *)iv,
                                               &thisEncipher);
    if (ccStatus == kCCSuccess) {
        size_t totalBytesWritten = 0;
        size_t plainTextBufferSize = [data length];
        size_t bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        uint8_t *bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t) );
        
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        
        uint8_t *ptr = bufferPtr;
        size_t remainingBytes = bufferPtrSize;
        size_t movedBytes = 0;
        ccStatus = CCCryptorUpdate(thisEncipher,
                                   (const void *)[data bytes],
                                   plainTextBufferSize,
                                   ptr,
                                   remainingBytes,
                                   &movedBytes);
        
        if (ccStatus == kCCSuccess) {
            ptr += movedBytes;
            remainingBytes -= movedBytes;
            totalBytesWritten += movedBytes;
            
            ccStatus = CCCryptorFinal(thisEncipher,
                                      ptr,
                                      remainingBytes,
                                      &movedBytes);
            totalBytesWritten += movedBytes;
            
            if (thisEncipher) {
                (void) CCCryptorRelease(thisEncipher);
                thisEncipher = NULL;
            }
            
            if (ccStatus == kCCSuccess) {
                NSData *cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
                NSString *cipherString = [GTMBase64 stringByEncodingData:cipherOrPlainText];
                if (bufferPtr) { free(bufferPtr); }
                return cipherString;
            }
        }
    }
    NSAssert(NO, @"DES加密失败");
    return nil;
}

+ (nonnull NSArray *)getSignArray:(nonnull NSDictionary *)postDic {
    NSArray *sortArr = [[postDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *key in sortArr) {
        if ([postDic objectForKey:key]) {
            [mArr addObject:[postDic objectForKey:key]];
        }
    }
    return mArr;
}

+ (nonnull NSString *)getMd5_32Bit_String:(nonnull NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (nonnull NSString *)getSign:(nonnull NSArray *)array {
    NSString *sign_base = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *str = [array objectAtIndex:i];
        if(![str isKindOfClass:[NSString class]]){
            str = [NSString stringWithFormat:@"%@",str];
        }
        if (str && str.length >= 1) {
            sign_base = [NSString stringWithFormat:@"%@%@",sign_base,str];
        }
    }
    
    sign_base = [NSString getMd5_32Bit_String:sign_base];
    return sign_base;
}

+ (nonnull NSString *)URLEncodedString:(nonnull NSString *)param {
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)param, nil, (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    return encodedValue;
}

@end
