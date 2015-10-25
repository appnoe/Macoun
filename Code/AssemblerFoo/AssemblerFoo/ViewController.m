//
//  ViewController.m
//  AssemblerFoo
//
//  Created by Klaus Rodewig on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//


#import "ViewController.h"
@import Foundation;
#import <Foundation/Foundation.h>

//#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
/*
    char *foo = "AAAAAAAAAA";
    NSString *theKey = @"BBBBBBBBBB";
    NSLog(@"&theKey: %p", &theKey);
    NSLog(@"theKey: %@", theKey);
    NSLog(@"foo: %s", foo);
    foo = nil;
    theKey = nil;

    id temp = objc_msgSend([NSString class], @selector(alloc));
    NSString *fooBar = objc_msgSend(temp, @selector(initWithString:), @"23");
    NSLog(@"fooBar: %@", fooBar);

*/

    Droid *theDroid = [[Droid alloc] initWithName:@"C3PO" andNumber:23];
    int x = 23;
    int y = 42;
    asm("mov %[result], %[value]" : [result] "=r" (y) : [value] "r" (x));

    NSLog(@"Droid: %@", theDroid);
    NSLog(@"Droid #: %d", theDroid.number);
    [theDroid someFooSecretStuff:23];
    [theDroid foo:42];
    printf("Foo");


//memset(foo,0,sizeof(foo));

	// Do any additional setup after loading the view, typically from a nib.
/*
    #if !(TARGET_IPHONE_SIMULATOR)
        zeegROscoGakSg ();
    #endif
    NSLog(@"Foo: %@", [[UIDevice currentDevice] systemName]);

    int i = 23;
    asm volatile ("mov %0, %1, ASR #1" : "=r"(i) : "r"(i));
    printf("arithmetic_shift_right is %d\n", i);
    asm("mov r0,r0");
*/
    NSLog(@"Bar: %@", [[UIDevice currentDevice] systemVersion]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goFoo:(id)sender {
    DLog(@"%s",__PRETTY_FUNCTION__);
    self.theLabel.text = @"Foobar";
    NSLog(@"Boofar");
}
@end
