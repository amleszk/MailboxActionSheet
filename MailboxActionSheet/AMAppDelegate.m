
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
    MBActionSheetViewItem *itemInfo = [[MBActionSheetViewItem alloc] init];
    itemInfo.iconImage = [MBFontImage info];
    itemInfo.description = @"More info";
    itemInfo.handler = ^{
        NSLog(@"More info");
    };

    MBActionSheetViewItem *itemLike = [[MBActionSheetViewItem alloc] init];
    itemLike.iconImage = [MBFontImage like];
    itemLike.description = @"Like";
    itemLike.handler = ^{
        NSLog(@"Like");
    };

    MBActionSheetViewItem *itemSearch = [[MBActionSheetViewItem alloc] init];
    itemSearch.iconImage = [MBFontImage search];
    itemSearch.description = @"Search";
    itemSearch.handler = ^{
        NSLog(@"Search");
    };

    MBActionSheetViewItem *itemStar = [[MBActionSheetViewItem alloc] init];
    itemStar.iconImage = [MBFontImage star];
    itemStar.description = @"Star";
    itemStar.handler = ^{
        NSLog(@"Star");
    };
    
    MBActionSheetViewItem *itemShare = [[MBActionSheetViewItem alloc] init];
    itemShare.iconImage = [MBFontImage share];
    itemShare.description = @"Share";
    itemShare.handler = ^{
        NSLog(@"Share");
    };

    MBActionSheetViewItem *itemMail = [[MBActionSheetViewItem alloc] init];
    itemMail.iconImage = [MBFontImage mail];
    itemMail.description = @"Mail";
    itemMail.handler = ^{
        NSLog(@"Mail");
    };

    MBActionSheetViewItem *itemUp = [[MBActionSheetViewItem alloc] init];
    itemUp.iconImage = [MBFontImage up];
    itemUp.description = @"Up";
    itemUp.handler = ^{
        NSLog(@"Up");
    };

    MBActionSheetViewItem *itemDown = [[MBActionSheetViewItem alloc] init];
    itemDown.iconImage = [MBFontImage down];
    itemDown.description = @"Down";
    itemDown.handler = ^{
        NSLog(@"Down");
    };

    MBActionSheetViewItem *itemLater = [[MBActionSheetViewItem alloc] init];
    itemLater.iconImage = [MBFontImage later];
    itemLater.description = @"Later";
    itemLater.handler = ^{
        NSLog(@"Later");
    };
    
    MBActionSheetViewItem *itemMore = [[MBActionSheetViewItem alloc] init];
    itemMore.iconImage = [MBFontImage more];
    itemMore.description = @"More";
    itemMore.handler = ^{
        NSLog(@"More");
    };

    NSArray *items = @[itemInfo,itemLike,itemSearch,itemStar,itemShare,itemMail,itemUp,itemDown,itemMore];
    MBActionSheetView* actionSheet = [[MBActionSheetView alloc] initWithItems:items];
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
