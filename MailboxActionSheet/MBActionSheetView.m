
#import "MBActionSheetView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kMBActionSheetViewItemSize = 100;
const static CGFloat kMBActionSheetViewItemCount = 3;
static CGSize kMBActionSheetViewSize = {kMBActionSheetViewItemCount*kMBActionSheetViewItemSize,
                                        kMBActionSheetViewItemCount*kMBActionSheetViewItemSize};
static CGFloat kMBActionSheetViewDisplayPadding = 10;

@interface MBActionSheetView ()
@property CALayer *backGroundLayer;
@property CALayer *verticalDiv1;
@property CALayer *verticalDiv2;
@property CALayer *horizontalDiv1;
@property CALayer *horizontalDiv2;
@property CGRect showFromRect;
@property NSArray *items;
@property NSMutableArray *itemViews;
@property UITapGestureRecognizer *tapOutsideMenuGesture;
@end

@implementation MBActionSheetView

-(id) initWithFrame:(CGRect)frame
{
    return [self initWithItems:nil];
}

-(id) initWithItems:(NSArray*)items
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _tapOutsideMenuGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutsideMenu:)];
        [self addGestureRecognizer:_tapOutsideMenuGesture];

        _backGroundLayer = [CALayer layer];
        _backGroundLayer.cornerRadius = 10;
        _backGroundLayer.borderWidth = 1.;
        _backGroundLayer.borderColor = [[UIColor colorWithWhite:0 alpha:0.8] CGColor];
        _backGroundLayer.masksToBounds = YES;
		_backGroundLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.5] CGColor];
        [self.layer addSublayer:_backGroundLayer];
        
        struct CGColor *borderColor = [[UIColor colorWithWhite:0 alpha:0.8] CGColor];
        
        _verticalDiv1 = [CALayer layer];
        _verticalDiv1.backgroundColor = borderColor;
        [self.layer addSublayer:_verticalDiv1];
        
        _verticalDiv2 = [CALayer layer];
        _verticalDiv2.backgroundColor = borderColor;
        [self.layer addSublayer:_verticalDiv2];
        
        _horizontalDiv1 = [CALayer layer];
        _horizontalDiv1.backgroundColor = borderColor;
        [self.layer addSublayer:_horizontalDiv1];
        
        _horizontalDiv2 = [CALayer layer];
        _horizontalDiv2.backgroundColor = borderColor;
        [self.layer addSublayer:_horizontalDiv2];
        
        _itemViews = [NSMutableArray arrayWithCapacity:items.count];
        for (MBActionSheetViewItem *item in items) {
            UIImageView *icon = [[UIImageView alloc] initWithImage:item.iconImage];
            
            //icon.backgroundColor = [UIColor redColor];
            icon.contentMode = UIViewContentModeCenter;
            [_itemViews addObject:icon];
            [self addSubview:icon];
        }
        
    }
    return self;
}

static inline CGPoint pointClampedToCGRect(CGPoint point, CGRect rect) {
        return CGPointMake(fminf(fmaxf(rect.origin.x , point.x), rect.origin.x+rect.size.width),
                       fminf(fmaxf(rect.origin.y , point.y), rect.origin.y+rect.size.height));
}

-(void) layoutSubviews
{
    CGSize boundsSize = self.bounds.size;
    
    CGPoint centerDisplayRect = (CGPoint){_showFromRect.origin.x+_showFromRect.size.width/2,_showFromRect.origin.y+_showFromRect.size.height/2};
    CGRect backGroundLayerFrame = (CGRect){
        .origin={floorf(centerDisplayRect.x-kMBActionSheetViewSize.width/2),floorf(centerDisplayRect.y-kMBActionSheetViewSize.height/2)},
        .size=kMBActionSheetViewSize
    };
    
    //Clamp display to boundsSize
    CGRect displayableRect = (CGRect){
        {kMBActionSheetViewDisplayPadding,kMBActionSheetViewDisplayPadding},
        {   boundsSize.width-kMBActionSheetViewSize.width-2*kMBActionSheetViewDisplayPadding,
            boundsSize.height-kMBActionSheetViewSize.height-2*kMBActionSheetViewDisplayPadding}};
    
    backGroundLayerFrame.origin = pointClampedToCGRect(backGroundLayerFrame.origin,displayableRect);
    
    _backGroundLayer.frame = backGroundLayerFrame;
    
    {//Vertical lines
        CGFloat borderX = _backGroundLayer.frame.origin.x + kMBActionSheetViewItemSize;
        CGFloat borderY = _backGroundLayer.frame.origin.y;
        CGRect verticalLineFrame = (CGRect){
            .origin={borderX,borderY},
            .size={1.,kMBActionSheetViewSize.height}
        };
        _verticalDiv1.frame = verticalLineFrame;
        verticalLineFrame.origin.x += kMBActionSheetViewItemSize;
        _verticalDiv2.frame = verticalLineFrame;
    }

    {//Horizontal lines
        CGFloat borderX = _backGroundLayer.frame.origin.x;
        CGFloat borderY = _backGroundLayer.frame.origin.y + kMBActionSheetViewItemSize;
        CGRect horizontalLineFrame = (CGRect){
            .origin={borderX,borderY},
            .size={kMBActionSheetViewSize.width,1.}
        };
        _horizontalDiv1.frame = horizontalLineFrame;
        horizontalLineFrame.origin.y += kMBActionSheetViewItemSize;
        _horizontalDiv2.frame = horizontalLineFrame;
    }
    
    //Buttons
    CGFloat x = backGroundLayerFrame.origin.x;
    CGFloat y = backGroundLayerFrame.origin.y;
    for (UIView *itemView in _itemViews) {
        itemView.frame =  (CGRect){
            .origin={x,y},
            .size={kMBActionSheetViewItemSize,kMBActionSheetViewItemSize}
        };
        x+= kMBActionSheetViewItemSize;
    }
}

#pragma mark -

-(void) showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated
{
    [view addSubview:self];
    self.frame = view.bounds;
    _showFromRect = rect;
    _tapOutsideMenuGesture.enabled = YES;
    [self setNeedsLayout];
    if (animated) {
        [self attachPopUpAnimation];
    }
}

-(void) didTapOutsideMenu:(UITapGestureRecognizer*)gesture
{
    [self hideAnimated];
}

-(void) hideAnimated
{
    _tapOutsideMenuGesture.enabled = FALSE;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void) attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    
    [_backGroundLayer addAnimation:animation forKey:@"popup"];
    [_verticalDiv1 addAnimation:animation forKey:@"popup"];
    [_verticalDiv2 addAnimation:animation forKey:@"popup"];
    [_horizontalDiv1 addAnimation:animation forKey:@"popup"];
    [_horizontalDiv2 addAnimation:animation forKey:@"popup"];
    for (UIView *itemView in _itemViews) {
        [itemView.layer addAnimation:animation forKey:@"popup"];
    }
}

@end

@implementation MBActionSheetViewItem
@end

