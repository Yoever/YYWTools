//
//  ViewController.m
//  YYWTools_iOS
//
//  Created by yoever on 15/11/20.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* encode & decode & cryptor */
    
    NSString *originString = @"YYWTools_By_Yoever";
    NSString *MD5String = [YYWCryptor MD5String:originString];
    //AES Encrypt
    NSData *AESEncryptData = [YYWCryptor AESEncryptString:originString];
    NSString *encryptedString = [YYWCryptor base64EncryptData:AESEncryptData];
    //AES Decrypt
    NSData *encryptedData = [YYWCryptor base64DecryptToDataWithString:encryptedString];
    NSData *decryptedData = [YYWCryptor AESCryptData:encryptedData withOperation:kCCDecrypt];
    NSString *decryptString = [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    /* color */
    
    NSString *hexColor = @"#000000";
    UIColor *color = yywColorFromHexColor(hexColor);
    UIColor *alphaColor = yywColorFromHexColorWithAlpha(hexColor, 0.5);
    NSString *hexString = yywHexColorFromColor([UIColor redColor]);
    
    /* time */
    
    NSString *timeStamp = yywTimeStampNow();
    NSString *time = yywTimeStandaredFromTimeStampWithFormatter(timeStamp, @"MM/dd HH:mm");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
