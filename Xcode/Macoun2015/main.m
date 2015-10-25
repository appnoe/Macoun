//
//  main.m
//  Macoun2015
//
//  Created by Klaus Rodewig on 24.10.15.
//  Copyright © 2015 Appnö UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMRSecUtils.h"
#import <CommonCrypto/CommonCryptor.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //--------------------------------------------------------------------
        NSString *cleartext = @"waff";
        NSLog(@"Cleartext: %@", cleartext);
        NSString *hash = [KMRSecUtils generateHashFromString:cleartext];
        NSLog(@"Hash :%@", hash);
        //--------------------------------------------------------------------
        cleartext = @"wuff";
        hash = [KMRSecUtils generateHashFromString:cleartext];
        NSLog(@"Cleartext: %@", cleartext);
        NSLog(@"Hash :%@", hash);
        //--------------------------------------------------------------------
        NSString *salt = [KMRSecUtils randomStringWithLength:32];
        NSLog(@"Salt: %@", salt);
        //--------------------------------------------------------------------
        // Hash
        NSMutableString *passwordWithHash = [NSMutableString stringWithFormat:@"%@%@", salt, cleartext];
        NSLog(@"Cleartext: %@", passwordWithHash);
        hash = [KMRSecUtils generateHashFromString:[NSString stringWithString:passwordWithHash]];
        NSLog(@"Hash :%@", hash);
        //--------------------------------------------------------------------
        // Keychain
        [KMRSecUtils storeSecretInKeychain:[hash dataUsingEncoding:NSUTF8StringEncoding] account:@"KMR" service:@"Macoun2015" label:@"Salt" accessGroup:nil protectionClass:nil];
        hash = @"";
        NSData *hashDataFromKeychain = [KMRSecUtils secretFromKeychainForAccount:@"KMR" service:@"Macoun2015" withLabel:@"Salt"];
        NSLog(@"Hash from keychain: %@", [[NSString alloc] initWithData:hashDataFromKeychain encoding:NSUTF8StringEncoding]);
        //--------------------------------------------------------------------
        // Encryption
        NSData *key = [hash dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:key andIV:nil];
        NSLog(@"Ciphertext: %@", encryptedData);
        // BUG BUG BUG
    
        encryptedData = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:key andIV:nil];
        NSLog(@"Ciphertext 2: %@", encryptedData);
        
        // IV
        NSData *firstIV = [KMRSecUtils randomDataWithLength:kCCBlockSizeAES128];
        NSData *encryptionKey = [KMRSecUtils randomDataWithLength:kCCBlockSizeAES128];
        NSData *firstCiphertext = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:encryptionKey andIV:firstIV];
        NSLog(@"Ciphertext with IV: %@", firstCiphertext);
        
        NSData *secondIV = [KMRSecUtils randomDataWithLength:kCCBlockSizeAES128];
        NSData *secondCiphertext = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:encryptionKey andIV:secondIV];
        NSLog(@"Same ciphertext with new IV: %@", secondCiphertext);
        
        // secure input key
        cleartext = @"baff";
        NSString *password = @"f00b@r"; // DON'T! DO! THAT! IN! REAL! LIFE! FOLX!
        NSData *newSalt = [KMRSecUtils randomDataWithLength:32];
        NSData *keyFromPassword = [KMRSecUtils keyFromPassword:password salt:newSalt];
        NSData *firstEncryptedWithSecureKey = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:keyFromPassword andIV:firstIV];
        NSData *secondEncryptedWithSecureKey = [KMRSecUtils encryptData:[cleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:keyFromPassword andIV:secondIV];
        NSLog(@"First key encryped ciphertext: %@", firstEncryptedWithSecureKey);
        NSLog(@"Second key encryped ciphertext: %@", secondEncryptedWithSecureKey);

        //--------------------------------------------------------------------
        // Decryption
        // insecure key
        NSData *firstCleartext = [KMRSecUtils decryptData:firstCiphertext withKey:encryptionKey];
        NSData *secondCleartext = [KMRSecUtils decryptData:firstCiphertext withKey:encryptionKey];
        NSLog(@"first Cleartext: %@", [[NSString alloc] initWithData:firstCleartext encoding:NSUTF8StringEncoding]);
        NSLog(@"second Cleartext: %@", [[NSString alloc] initWithData:secondCleartext encoding:NSUTF8StringEncoding]);
        // secure key
        firstCleartext = [KMRSecUtils decryptData:firstEncryptedWithSecureKey withKey:keyFromPassword];
        secondCleartext = [KMRSecUtils decryptData:secondEncryptedWithSecureKey withKey:keyFromPassword];
        NSLog(@"first secured Cleartext: %@", [[NSString alloc] initWithData:firstCleartext encoding:NSUTF8StringEncoding]);
        NSLog(@"second secured Cleartext: %@", [[NSString alloc] initWithData:secondCleartext encoding:NSUTF8StringEncoding]);
        
        
//        NSData *theEncryptionKey = [KMRSecUtils randomDataWithLength:kCCBlockSizeAES128];
//        theEncryptedData = [KMRSecUtils encryptData:[theCleartext dataUsingEncoding:NSUTF8StringEncoding] withKey:theEncryptionKey andIV:theIV];
//        NSLog(@"Ciphertext with IV: %@", theEncryptedData);
    }
    return 0;
}
