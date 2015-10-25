//
//  Droid.m
//  AssemblerFoo
//
//  Created by Klaus Rodewig on 04.10.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "Droid.h"

@implementation Droid

-(id)initWithName:(NSString*)theName andNumber:(int)theNumber{
    self = [super init];
    if (self) {
        _name = theName;
        _number = theNumber;
    }
    return self;
}

-(NSString *)description{
    return self.name;
}


-(void)someFooSecretStuff:(int)theKey{
    char buf[10];
    int i;
    for (i=0; i<sizeof(buf); ++i)
        buf[i] = 'A';
    memset(buf,0,sizeof(buf));
}

-(void)foo:(int)x {
    char buf[10];
    int i;
    for (i=0; i<sizeof(buf); ++i)
        buf[i]=x++;
    memset(buf,0,sizeof(buf));
    asm volatile("" : : "r"(&buf) : "memory");
}



@end