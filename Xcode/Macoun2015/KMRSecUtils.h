//
//  KMRSecUtils.h
//  Macoun2015
//
//  Created by Klaus Rodewig on 24.10.15.
//  Copyright © 2015 Appnö UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMRSecUtils : NSObject
#pragma mark Hashing
+(NSString *)generateHashFromString:(NSString *)inString;
#pragma mark Utils
+(NSData *)randomDataWithLength:(size_t)inLength;
+(NSString *)randomStringWithLength:(NSInteger)inLength;
#pragma mark Keychain
+(OSStatus)storeSecretInKeychain:(NSData *)inSecret
                         account:(NSString *)inAccount
                         service:(NSString *)inService
                           label:(NSString * )inLabel
                     accessGroup:(NSString *)inAccessGroup
                 protectionClass:(CFTypeRef)inProtectionClass;
+(NSData *)secretFromKeychainForAccount:(NSString *)inAccount
                                service:(NSString *)inService
                              withLabel:(NSString * )inLabel;
#pragma mark Encryption
+(NSData *)encryptData:(NSData *)inData withKey:(NSData *)inKey andIV:(NSData *)inIV;
+(NSData *)decryptData:(NSData *)inData withKey:(NSData *)inKey;
+(NSData *)keyFromPassword:(NSString *)inPassword salt:(NSData *)inSalt;
@end
