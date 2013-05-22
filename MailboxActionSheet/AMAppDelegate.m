
#import "AMAppDelegate.h"
#import "MBActionSheetView.h"
#import "MBFontImage.h"

@interface RootViewController : UIViewController
@property MBActionSheetView* actionSheet;
@end

@implementation RootViewController
-(void) viewDidLoad
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMBActionSheetView:)];
    [self.view addGestureRecognizer:tap];
}

-(void) showMBActionSheetView:(UITapGestureRecognizer*)sender {
    MBActionSheetViewItem *item = [[MBActionSheetViewItem alloc] init];
    item.iconImage = [MBFontImage info];
    item.description = @"More info";
    item.handler = ^{
        NSLog(@"More info");
    };
    
    MBActionSheetView* actionSheet = [[MBActionSheetView alloc] initWithItems:@[item]];
    [actionSheet showFromRect:(CGRect){[sender locationInView:self.view],CGSizeZero} inView:self.view animated:YES];
}


@end

@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
