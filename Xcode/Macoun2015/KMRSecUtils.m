//
//  KMRSecUtils.m
//  Macoun2015
//
//  Created by Klaus Rodewig on 24.10.15.
//  Copyright © 2015 Appnö UG (haftungsbeschränkt). All rights reserved.
//

#import "KMRSecUtils.h"
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCryptor.h>

#define kSecDefaultProtectionClass kSecAttrAccessibleWhenUnlockedThisDeviceOnly
const NSUInteger    kEncIVLength = kCCBlockSizeAES128;
const NSUInteger    kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger    kPBKDFRounds = 20000;

@implementation KMRSecUtils

+(NSString *)generateHashFromString:(NSString *)inString{
    NSMutableString *theHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    unsigned char passwordChars[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([inString UTF8String], (int)[inString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], passwordChars);
    for(int i=0; i< CC_SHA256_DIGEST_LENGTH; i++){
        [theHash appendString:[NSString stringWithFormat:@"%02x", passwordChars[i]]];
    }
    return theHash;
}

+(NSData *)randomDataWithLength:(size_t)inLength {
    NSMutableData *theData = [NSMutableData dataWithLength:inLength];
    int theResult = SecRandomCopyBytes(kSecRandomDefault,
                                       inLength,
                                       theData.mutableBytes);
    if(theResult == 0){
        return theData;
    } else {
        NSLog(@"IV generation failed");
        return nil;
    }
}

+(NSString *)randomStringWithLength:(NSInteger)inLength{
    NSString *theCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!§$%&/()=?*+#-_.:; ";
    NSMutableString *theKey = [NSMutableString new];
    for(int i=0; i<=inLength; i++){
        NSUInteger thePosition = arc4random_uniform((int)theCharacters.length) + 0;
        [theKey appendString:[NSString stringWithFormat:@"%c", [theCharacters characterAtIndex:thePosition]]];
    }
    return [NSString stringWithString:[theKey copy]];
}

+(OSStatus)storeSecretInKeychain:(NSData *)inSecret
                         account:(NSString *)inAccount
                         service:(NSString *)inService
                           label:(NSString * )inLabel
                     accessGroup:(NSString *)inAccessGroup
                 protectionClass:(CFTypeRef)inProtectionClass{
    NSMutableDictionary *theSearchDict = [NSMutableDictionary dictionary];
    [theSearchDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [theSearchDict setObject:inService forKey:(__bridge id)kSecAttrService];
    [theSearchDict setObject:inLabel forKey:(__bridge id)kSecAttrLabel];
    [theSearchDict setObject:inAccount forKey:(__bridge id)kSecAttrAccount];
    
    NSMutableDictionary *theWriteDict = [NSMutableDictionary dictionary];
    [theWriteDict setDictionary:theSearchDict];
    CFTypeRef theProtectionClass = inProtectionClass ? inProtectionClass : kSecDefaultProtectionClass;
    [theWriteDict setObject:(__bridge id)theProtectionClass forKey:(__bridge id)kSecAttrAccessible];
    [theWriteDict setObject:inSecret forKey:(__bridge id)kSecValueData];
    if(inAccessGroup != nil)
        [theWriteDict setObject:inAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    
    NSMutableDictionary *theUpdateDict = [NSMutableDictionary dictionary];
    [theUpdateDict setObject:inSecret forKey:(__bridge id)kSecValueData];
    
    OSStatus theStatus;
    
    if((theStatus = SecItemAdd((__bridge CFDictionaryRef)theWriteDict, NULL)) == errSecDuplicateItem){
        theStatus =  SecItemUpdate((__bridge CFDictionaryRef)theSearchDict, ((__bridge CFDictionaryRef)theUpdateDict));
    }
    NSLog(@"Keychain status: %ld", (long)theStatus);
    return theStatus;
}

+(NSData *)secretFromKeychainForAccount:(NSString *)inAccount
                                service:(NSString *)inService
                              withLabel:(NSString * )inLabel{
    if(inAccount != nil){
        NSMutableDictionary *theQueryDict = [NSMutableDictionary dictionary];
        [theQueryDict setObject:(__bridge NSString *)kSecClassGenericPassword forKey:(__bridge NSString *)kSecClass];
        [theQueryDict setObject:inAccount forKey:(__bridge id)kSecAttrAccount];
        [theQueryDict setObject:inLabel forKey:(__bridge id)kSecAttrLabel];
        [theQueryDict setObject:inService forKey:(__bridge id)kSecAttrService];
        [theQueryDict setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
        
        CFDataRef thePWData = nil;
        OSStatus theStatus = SecItemCopyMatching((__bridge CFDictionaryRef)theQueryDict, (CFTypeRef*)&thePWData);
        NSLog(@"Keychain status: %ld", (long)theStatus);
        if(theStatus == errSecSuccess){
            NSData *result = (__bridge_transfer NSData*)thePWData;
            return result;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+(NSData *)encryptData:(NSData *)inData withKey:(NSData *)inKey andIV:(NSData *)inIV{
    size_t outLength;
    
    NSMutableData *theCipherText = [NSMutableData dataWithLength:inData.length + kAlgorithmBlockSize];
    
    NSData *theEncryptionKey = inKey;
    
    CCCryptorStatus theResult = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding,
                                        theEncryptionKey.bytes,
                                        theEncryptionKey.length,
                                        inIV.bytes,
                                        inData.bytes,
                                        inData.length,
                                        theCipherText.mutableBytes,
                                        theCipherText.length,
                                        &outLength);
    
    if (theResult == kCCSuccess) {
        theCipherText.length = outLength;
        [theCipherText appendData:inIV];
        return [NSData dataWithData:theCipherText];
    } else {
        return nil;
    }
}

+(NSData *)decryptData:(NSData *)inData withKey:(NSData *)inKey{
    if([inData isKindOfClass:[NSData class]]){
        size_t outLength;
        
        NSData *theIV = [inData subdataWithRange:NSMakeRange((inData.length-kEncIVLength), kEncIVLength)];
        NSData *theCipherText = [inData subdataWithRange:NSMakeRange(0, (inData.length-kEncIVLength))];
        NSMutableData *clearData = [NSMutableData dataWithLength:inData.length + kAlgorithmBlockSize];
        CCCryptorStatus theResult = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding,
                                            inKey.bytes,
                                            inKey.length,
                                            theIV.bytes,
                                            theCipherText.bytes,
                                            theCipherText.length,
                                            clearData.mutableBytes,
                                            clearData.length,
                                            &outLength);
        
        if (theResult == kCCSuccess) {
            clearData.length = outLength;
            return [NSData dataWithData:clearData];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+(NSData *)keyFromPassword:(NSString *)inPassword salt:(NSData *)inSalt {
    NSMutableData *theEncryptionKey = [NSMutableData dataWithLength:kAlgorithmBlockSize];
    int theResult = CCKeyDerivationPBKDF(kCCPBKDF2,
                                         inPassword.UTF8String,
                                         [inPassword lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                                         inSalt.bytes,
                                         inSalt.length,
                                         kCCPRFHmacAlgSHA512,
                                         kPBKDFRounds,
                                         theEncryptionKey.mutableBytes,
                                         theEncryptionKey.length);
    if(theResult == 0){
        return theEncryptionKey;
    } else {
        return nil;
    }
}

@end
