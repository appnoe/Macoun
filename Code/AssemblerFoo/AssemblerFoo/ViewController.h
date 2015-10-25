//
//  ViewController.h
//  AssemblerFoo
//
//  Created by Klaus Rodewig on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Droid.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;

- (IBAction)goFoo:(id)sender;

@end
