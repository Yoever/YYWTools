//
//  YYWCryptor.m
//  YYWTools
//
//  Created by yoever on 15/11/16.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import "YYWCryptor.h"

@implementation YYWCryptor

#pragma mark - ---------------------- SHA1 ----------------------

+ (NSString *)SHA1StringWithString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [YYWCryptor SHA1StringWithData:stringData];
}
+ (NSString *)SHA1StringWithData:(NSData *)data
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02X", digest[i]];
    }
    return [output copy];
}
#pragma mark - ---------------------- MD5 ----------------------

+ (NSString *)MD5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_LONG length = (int)strlen(cStr);
    CC_MD5( cStr, length, result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - ---------------------- BASE64 ----------------------

+ (NSString *)base64EncryptString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    NSData      *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *result = [YYWCryptor base64EncryptData:stringData];
    return result;
}
+ (NSString *)base64DecryptString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    NSData      *data = [YYWCryptor base64DecryptToDataWithString:string];
    NSString    *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}
+ (NSString *)base64EncryptData:(NSData *)data
{
    return [data base64EncodedStringWithOptions:0];
}
+ (NSData *)base64DecryptToDataWithString:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return data;
}
#pragma mark - ---------------------- AES ----------------------

+ (NSData *)AESEncryptString:(NSString *)string
{
    NSData      *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData      *encodedData = [YYWCryptor AESCryptData:stringData
                                          withOperation:kCCEncrypt];
    return      encodedData;
}
+ (NSString *)AESDecryptString:(NSString *)encodedString
{
    NSData      *encodedData = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
    NSData      *decodedData = [YYWCryptor AESCryptData:encodedData
                                     withOperation:kCCDecrypt];
    NSString    *result = [[NSString alloc]initWithData:decodedData encoding:NSUTF8StringEncoding];
    return      result;
}
+ (NSData *)AESCryptData:(NSData *)data withOperation:(CCOperation)operation
{
    NSData *ivData = [kYYWAESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [kYYWAESIv dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = [data length]+kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,            //CCOperation 加密或者解密
                                          kCCAlgorithmAES128,   //CCAlgorithm 算法
                                          kCCOptionPKCS7Padding,//CCOptions 默认CBC模式(PKCS7Padding)(另外有ECB模式可选)
                                          keyData.bytes,        //key  (const void) AES的KEY
                                          kCCBlockSizeAES128,   //keyLength  (size_t)16位key长度
                                          ivData.bytes,         //iv  (const void)偏移量
                                          data.bytes,           //dataIn  (const void)输入数据
                                          data.length,          //dataIn length  (size_t)输入数据长度
                                          buffer,               //dataOut  (size_t)输出数据
                                          bufferSize,           //dataOutAvailable  (size_t)输出数据长度
                                          &numBytesEncrypted);  //dataOutMoved  (size_t)偏移后的数据长度
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    return nil;
}

#pragma mark - ---------------------- RSA ----------------------

+ (NSData *)RSAEncryptString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *results = [YYWCryptor RSAEncryptData:data];
    return results;
}
+ (NSData *)RSAEncryptData:(NSData *)data
{
    SecKeyRef   pubKey = [YYWCryptor getRSAPublicKey];
    
    size_t      cipherBufferSize = SecKeyGetBlockSize(pubKey);
    uint8_t     *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    
    size_t      blockSize = cipherBufferSize - 1;
    size_t      loopCount = (size_t)ceil([data length]/(double)blockSize);
    
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    
    for (int i = 0 ; i < loopCount ; i++) {
        NSUInteger  bufferSize = MIN(blockSize,[data length] - i * blockSize);
        NSData      *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus    status = SecKeyEncrypt(pubKey,
                                           kSecPaddingPKCS1,
                                           (const uint8_t *)[buffer bytes],
                                           [buffer length],
                                           cipherBuffer,
                                           &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    return encryptedData;
}
+ (NSData *)RSADecryptData:(NSData *)RSAData
{
    SecKeyRef       key = [YYWCryptor getRSAPrivateKey];
    
    size_t          cipherBufferSize = SecKeyGetBlockSize(key);
    size_t          keyBufferSize = [RSAData length];
    
    NSMutableData   *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus        status = SecKeyDecrypt(key,
                                    kSecPaddingPKCS1,
                                    (const uint8_t *) [RSAData bytes],
                                    cipherBufferSize,
                                    [bits mutableBytes],
                                    &keyBufferSize);
    if (status == noErr) {
        
    }
    [bits setLength:keyBufferSize];
    
    return bits;
}
+ (NSString *)RSADecryptToStringWithData:(NSData *)RSAData
{
    NSData      *data = [YYWCryptor RSADecryptData:RSAData];
    NSString    *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return      resultString;
}
+ (SecKeyRef)getRSAPrivateKey
{
    NSData              *privateData = [YYWCryptor base64DecryptToDataWithString:[kYYWRSAPrivateKey copy]];
    SecKeyRef           privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: kYYWRSAPrivateKeyPassword forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef          items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus            securityError = SecPKCS12Import((__bridge CFDataRef) privateData,
                                                        (__bridge CFDictionaryRef)options,
                                                        &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef     identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef      identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    return privateKeyRef;
}
+ (SecKeyRef)getRSAPublicKey
{
    NSData      *publicData = [YYWCryptor base64DecryptToDataWithString:[kYYWRSAPublicKey copy]];
    SecTrustRef trust = [YYWCryptor getSecTrustRefFromCerData:publicData];
    SecKeyRef   publicKey = SecTrustCopyPublicKey(trust);
    return      publicKey;
}
+ (SecTrustRef) getSecTrustRefFromCerData:(NSData *)data {
    CFDataRef myCertData = (__bridge CFDataRef)data;
    
    SecCertificateRef myCert;
    myCert = SecCertificateCreateWithData(kCFAllocatorDefault, myCertData);
    
    SecPolicyRef    myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef     myTrust;
    OSStatus        status = SecTrustCreateWithCertificates(myCert,
                                                            myPolicy,
                                                            &myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    if (myPolicy) {
        CFRelease(myPolicy);
    }
    if (myCert) {
        CFRelease(myCert);
    }
    return myTrust;
}
@end





