//
//  NSString+Encoding.h
//  LYFootballLottery
//
//  Created by Tsz on 2017/1/11.
//  Copyright © 2017年 Tsz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encoding)

- (nonnull NSString *)encodingWithDESKey:(nonnull NSString *)desKey;

+ (nonnull NSArray *)getSignArray:(nonnull NSDictionary *)postDic;
+ (nonnull NSString *)getMd5_32Bit_String:(nonnull NSString *)srcString;
+ (nonnull NSString *)getSign:(nonnull NSArray*)array;

+ (nonnull NSString *)URLEncodedString:(nonnull NSString *)param;


@end
