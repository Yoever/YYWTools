//
//  YYWCryptor.h
//  YYWTools
//
//  Created by yoever on 15/11/16.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

//    AES
// Key's length is 16 by default 
// KEY默认为16位长度 
static NSString const *kYYWAESKey = @"ynsjyyw@icloud..";
static NSString const *kYYWAESIv = @"ynsjyyw@icloud.com";

//    RSA
//      please get public&private key string from certs file first
//      请先根据证书文件获取字符串
// 根据公钥密钥文件得到的base64字符串
// key data base64 string
static NSString const *kYYWRSAPublicKey = @"";
// key data base64 string
static NSString const *kYYWRSAPrivateKey = @"MIIGcQIBA...";
//key's password
static NSString const *kYYWRSAPrivateKeyPassword = @"****";


@interface YYWCryptor : NSObject

#pragma mark - ---------------------- SHA1 ----------------------
/**
 *  计算字符串SHA1
 */
+ (NSString *)SHA1StringWithString:(NSString *)string;
/**
 *  计算Data SHA1
 */
+ (NSString *)SHA1StringWithData:(NSData *)data;
#pragma mark - ---------------------- MD5 ----------------------
/**
 *  对字符串进行MD5
 */
+ (NSString *)MD5String:(NSString *)string;

#pragma mark - ---------------------- BASE64 ----------------------
/**
 *  对字符串进行BASE64
 */
+ (NSString *)base64EncryptString:(NSString *)string NS_AVAILABLE_IOS(7_0);
/**
 *  把base64字符串解成字符串
 */
+ (NSString *)base64DecryptString:(NSString *)string NS_AVAILABLE_IOS(7_0);
/**
 *  对data BASE64编码
 */
+ (NSString *)base64EncryptData:(NSData *)data NS_AVAILABLE_IOS(7_0);
/**
 *  对BASE64编码过的字符串解码成data
 */
+ (NSData *)base64DecryptToDataWithString:(NSString *)string NS_AVAILABLE_IOS(7_0);

#pragma mark - ---------------------- AES ----------------------
/**
 *  AES加密字符串
 */
+ (NSData *)AESEncryptString:(NSString *)string;
/**
 *  AES解密字符串
 */
+ (NSString *)AESDecryptString:(NSString *)encodedString;
/**
 *  加密/解密 data
 */
+ (NSData *)AESCryptData:(NSData *)data withOperation:(CCOperation)operation;

#pragma mark - ---------------------- RSA ----------------------
/**
 *  对字符串RSA加密
 */
+ (NSData *)RSAEncryptString:(NSString *)string;
/**
 *  对data进行RSA加密
 */
+ (NSData *)RSAEncryptData:(NSData *)data;
/**
 *  对RSA加密的data解密
 */
+ (NSData *)RSADecryptData:(NSData *)RSAData;
/**
 *  解密成字符串
 */
+ (NSString *)RSADecryptToStringWithData:(NSData *)RSAData;
@end
