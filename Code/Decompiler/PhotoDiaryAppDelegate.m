#import "PhotoDiaryAppDelegate.h"
#import "PhotoDiaryViewController.h"

@interface PhotoDiaryAppDelegate()

@property (nonatomic, retain, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, retain, readwrite) UIPopoverController *popoverController;

@end

@implementation PhotoDiaryAppDelegate

@synthesize window;
@synthesize overviewButton;
@synthesize viewController;
@synthesize managedObjectContext;

@synthesize managedObjectModel;
@synthesize storeCoordinator;
@synthesize popoverController;

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.storeCoordinator = nil;
    self.popoverController = nil;
    self.overviewButton = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)inApplication {
    srand((unsigned) [NSDate timeIntervalSinceReferenceDate]);
}

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        self.managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:theURL] autorelease];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"Diary.sqlite"];
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:theURL options:nil error:&theError]) {
            self.storeCoordinator = theCoordinator;
        }
        else {
            NSLog(@"storeCoordinator: %@", theError);
        }
        [theCoordinator release];
    }
    return storeCoordinator;
}

- (void)showPhotoDiaryViewController:(id)inSender {
    
}

#pragma mark UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
          popoverController:(UIPopoverController *)inPopoverController 
  willPresentViewController:(UIViewController *)inViewController {
}

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
     willHideViewController:(UIViewController *)inViewController 
          withBarButtonItem:(UIBarButtonItem *)inBarButtonItem 
       forPopoverController:(UIPopoverController *)inPopoverController {
    self.popoverController = inPopoverController;
    self.overviewButton = inBarButtonItem;
}

- (void)splitViewController:(UISplitViewController *)inSplitViewController 
     willShowViewController:(UIViewController *)inViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)inBarButtonItem {
    self.popoverController = nil;
    self.overviewButton = nil;
}

@end
