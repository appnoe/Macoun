//
//  Droid.h
//  AssemblerFoo
//
//  Created by Klaus Rodewig on 04.10.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Droid : NSObject

@property (strong) NSString *name;
@property int number;

-(id)initWithName:(NSString*)theName andNumber:(int)theNumber;
-(void)someFooSecretStuff:(int)theKey;
-(void)foo:(int)x;
@end
