#import <Foundation/Foundation.h>

    @interface Droid : NSObject
    {
        NSString *_name;
        int _number;
    }

    - (id)initWithName: (NSString *)name number: (int)number;

    @property (strong) NSString *name;
    @property int number;

    @end

    @implementation Droid

    @synthesize name = _name, number = _number;

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

    NSString *MyFunction(NSString *parameter)
    {
        NSString *string2 = [@"Prefix" stringByAppendingString: parameter];
        NSLog(@"%@", string2);
        return string2;
    }

    int main(int argc, char **argv)
    {
        @autoreleasepool
        {
            Droid *theDroid = [[Droid alloc] initWithName: @"name" number:23];
            NSString *theString= MyFunction([theDroid name]);
            NSLog(@"%@", theString);
            return 0;
        }
    }

