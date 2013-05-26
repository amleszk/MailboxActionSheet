
#import <UIKit/UIKit.h>

@class MBActionSheetViewItem;

@interface MBActionSheetView : UIView

-(void) showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated;

-(void) hideAnimated;

-(id) initWithItems:(NSArray*)items;

@end


typedef void (^MBActionSheetHandler)(void);

@interface MBActionSheetViewItem : NSObject
@property (strong) UIImage *iconImage;
@property (strong) NSString *description;
@property (copy) MBActionSheetHandler handler;
@end
