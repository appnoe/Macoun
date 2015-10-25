#import <Foundation/Foundation.h>

@interface Droid : NSObject
	
- (id)initWithName: (NSString *)name number: (int)number;

@property (strong) NSString *name;
@property int number;
@property int age;

@end


@implementation Droid

- (id)initWithName: (NSString *)name number: (int)number
{
	if((self = [super init]))
		{
			_name = name;
			_number = number;
        }	
	return self;
    }

@end

NSString *droidName(NSString *parameter)
{
	NSString *theName = [@"Name: " stringByAppendingString: parameter];
	NSLog(@"%@", theName);
	return theName;
}

int main(int argc, char **argv)
{
	@autoreleasepool
	{
		Droid *theDroid = [[Droid alloc] initWithName: @"C3PO" number: 42];
		NSString *string = droidName([theDroid name]);
		NSLog(@"Droid# %d: %@", [theDroid number], [theDroid name]);
		return 0;
	}
}

