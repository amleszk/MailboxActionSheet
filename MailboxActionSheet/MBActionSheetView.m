
#import "MBActionSheetView.h"
#import <QuartzCore/QuartzCore.h>


@interface MBActionSheetViewTouchInterceptView : UIView
-(id) initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
@end

const static CGFloat kMBActionSheetViewItemSize = 93;
const static CGFloat kMBActionSheetViewItemCount = 3;
static CGSize kMBActionSheetViewSize = {kMBActionSheetViewItemCount*kMBActionSheetViewItemSize,
                                        kMBActionSheetViewItemCount*kMBActionSheetViewItemSize};
static CGFloat kMBActionSheetViewDisplayPadding = 12;
static CGFloat kMBActionSheetViewDisplayItemIconPadding = 15;
static CGFloat kMBActionSheetViewDisplayItemLabelPadding = 3;

@interface MBActionSheetView ()
@property CALayer *backGroundLayer;
@property CALayer *verticalDiv1;
@property CALayer *verticalDiv1Light;
@property CALayer *verticalDiv2;
@property CALayer *verticalDiv2Light;
@property CALayer *horizontalDiv1;
@property CALayer *horizontalDiv1Light;
@property CALayer *horizontalDiv2;
@property CALayer *horizontalDiv2Light;
@property CGRect showFromRect;
@property NSArray *items;
@property NSMutableArray *itemIconViews;
@property NSMutableArray *itemLabelViews;
@property NSMutableArray *itemTouchViews;
@property NSMutableArray *itemTouchBlocks;
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
        
        
        //Borders
        struct CGColor *borderColor = [[UIColor colorWithWhite:0.2 alpha:0.5] CGColor];
        struct CGColor *borderColorLight = [[UIColor colorWithWhite:0.6 alpha:0.5] CGColor];
        
        _verticalDiv1 = [CALayer layer];
        _verticalDiv1.backgroundColor = borderColor;
        [self.layer addSublayer:_verticalDiv1];
        
        _verticalDiv1Light = [CALayer layer];
        _verticalDiv1Light.backgroundColor = borderColorLight;
        [self.layer addSublayer:_verticalDiv1Light];
        
        _verticalDiv2 = [CALayer layer];
        _verticalDiv2.backgroundColor = borderColor;
        [self.layer addSublayer:_verticalDiv2];

        _verticalDiv2Light = [CALayer layer];
        _verticalDiv2Light.backgroundColor = borderColorLight;
        [self.layer addSublayer:_verticalDiv2Light];
        
        _horizontalDiv1 = [CALayer layer];
        _horizontalDiv1.backgroundColor = borderColor;
        [self.layer addSublayer:_horizontalDiv1];

        _horizontalDiv1Light = [CALayer layer];
        _horizontalDiv1Light.backgroundColor = borderColorLight;
        [self.layer addSublayer:_horizontalDiv1Light];

        _horizontalDiv2 = [CALayer layer];
        _horizontalDiv2.backgroundColor = borderColor;
        [self.layer addSublayer:_horizontalDiv2];

        _horizontalDiv2Light = [CALayer layer];
        _horizontalDiv2Light.backgroundColor = borderColorLight;
        [self.layer addSublayer:_horizontalDiv2Light];
        
        _itemIconViews = [NSMutableArray arrayWithCapacity:items.count];
        _itemLabelViews = [NSMutableArray arrayWithCapacity:items.count];
        _itemTouchViews = [NSMutableArray arrayWithCapacity:items.count];
        _itemTouchBlocks = [NSMutableArray arrayWithCapacity:items.count];
        
        for (MBActionSheetViewItem *item in items) {
            
            UIView *touchIntercept = [[MBActionSheetViewTouchInterceptView alloc] initWithFrame:CGRectZero target:self action:@selector(didTapMenuItem:)];
            [_itemTouchViews addObject:touchIntercept];
            [self addSubview:touchIntercept];
            
            [_itemTouchBlocks addObject:item.handler];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:item.iconImage];
            icon.contentMode = UIViewContentModeCenter;
            [_itemIconViews addObject:icon];
            [self addSubview:icon];
            
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            itemLabel.text = item.description;
            itemLabel.textColor = [UIColor whiteColor];
            itemLabel.backgroundColor = [UIColor clearColor];
            itemLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.];
            [itemLabel sizeToFit];
            [_itemLabelViews addObject:itemLabel];
            [self addSubview:itemLabel];
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
    
    //Clamp display rect to boundsSize with padding
    CGRect displayableRect = (CGRect){
        {kMBActionSheetViewDisplayPadding,kMBActionSheetViewDisplayPadding},
        {   boundsSize.width-kMBActionSheetViewSize.width-2*kMBActionSheetViewDisplayPadding,
            boundsSize.height-kMBActionSheetViewSize.height-2*kMBActionSheetViewDisplayPadding}};
    
    backGroundLayerFrame.origin = pointClampedToCGRect(backGroundLayerFrame.origin,displayableRect);
    
    _backGroundLayer.frame = backGroundLayerFrame;
    
    {//Vertical lines
        CGFloat borderX = _backGroundLayer.frame.origin.x + kMBActionSheetViewItemSize;
        CGFloat borderY = _backGroundLayer.frame.origin.y - 1;
        CGRect verticalLineFrame = (CGRect){
            .origin={borderX,borderY+1},
            .size={1.,kMBActionSheetViewSize.height-2}
        };
        _verticalDiv1.frame = verticalLineFrame;
        verticalLineFrame.origin.x+=1;
        _verticalDiv1Light.frame = verticalLineFrame;
        verticalLineFrame.origin.x += kMBActionSheetViewItemSize - 1;
        _verticalDiv2.frame = verticalLineFrame;
        verticalLineFrame.origin.x+=1;
        _verticalDiv2Light.frame = verticalLineFrame;
    }

    {//Horizontal lines
        CGFloat borderX = _backGroundLayer.frame.origin.x - 1;
        CGFloat borderY = _backGroundLayer.frame.origin.y + kMBActionSheetViewItemSize;
        CGRect horizontalLineFrame = (CGRect){
            .origin={borderX+1,borderY},
            .size={kMBActionSheetViewSize.width-2,1.}
        };
        _horizontalDiv1.frame = horizontalLineFrame;
        horizontalLineFrame.origin.y+=1;
        _horizontalDiv1Light.frame = horizontalLineFrame;
        horizontalLineFrame.origin.y += kMBActionSheetViewItemSize - 1;
        _horizontalDiv2.frame = horizontalLineFrame;
        horizontalLineFrame.origin.y+=1;
        _horizontalDiv2Light.frame = horizontalLineFrame;
    }

    {//Touch intercept
        [self threeByThreeGridLayoutWithFrame:backGroundLayerFrame
                                        items:_itemTouchViews
                                    itemBlock:^(UIView *view, CGFloat x, CGFloat y) {
            CGRect itemFrame = (CGRect){
                .origin={x,y},
                .size={kMBActionSheetViewItemSize,kMBActionSheetViewItemSize}
            };
            itemFrame = CGRectInset(itemFrame, 1., 1.);
            view.frame = itemFrame;
        }];
    }
    {//Icons
        [self threeByThreeGridLayoutWithFrame:backGroundLayerFrame
                                        items:_itemIconViews
                                    itemBlock:^(UIView *view, CGFloat x, CGFloat y) {
                view.frame =  (CGRect){
                    .origin={x,y},
                    .size={kMBActionSheetViewItemSize,kMBActionSheetViewItemSize-kMBActionSheetViewDisplayItemIconPadding}
                };
        }];
    }
    {//Labels
        
        [self threeByThreeGridLayoutWithFrame:backGroundLayerFrame
                                        items:_itemLabelViews
                                    itemBlock:^(UIView *view, CGFloat x, CGFloat y) {
            CGRect existingFrame = view.frame;
            view.frame = (CGRect){
                .origin={
                    floorf(x+kMBActionSheetViewItemSize/2-existingFrame.size.width/2),
                    y+kMBActionSheetViewItemSize-existingFrame.size.height-kMBActionSheetViewDisplayItemLabelPadding},
                .size=existingFrame.size
            };
        }];
    }
}

-(void) threeByThreeGridLayoutWithFrame:(CGRect)frame
                                  items:(NSArray*)items
                              itemBlock:(void (^)(UIView *view, CGFloat x,CGFloat y))layoutItemBlock
{
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    NSUInteger i=0;
    for (UIView *itemView in items) {
        if (i && i%3==0) {
            y+= kMBActionSheetViewItemSize;
            x = frame.origin.x;
        }

        layoutItemBlock(itemView,x,y);
        x+= kMBActionSheetViewItemSize;
        i++;
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
        [self attachPopUpAnimationWithReverse:NO completion:nil];
    }
}

-(void) didTapMenuItem:(UITapGestureRecognizer*)gesture
{
    NSUInteger itemIndex = NSNotFound, i=0;
    for (id view in _itemTouchViews) {
        if (view == gesture.view) {
            itemIndex = i;
            break;
        }
        i++;
    }
    if (itemIndex != NSNotFound) {
        ((void (^)(void))_itemTouchBlocks[itemIndex])();
        [self hideAnimated];
    } else {
        NSAssert(NO, @"%@ view is invalid",gesture.view);
    }
}

-(void) didTapOutsideMenu:(UITapGestureRecognizer*)gesture
{
    [self hideAnimated];
}

-(void) hideAnimated
{
    _tapOutsideMenuGesture.enabled = FALSE;
    [self attachPopUpAnimationWithReverse:YES completion:^{
        [self removeFromSuperview];
    }];
}

- (void) attachPopUpAnimationWithReverse:(BOOL)reverse completion:(void (^)(void))completion
{
    static NSTimeInterval animDuration = 0.3;
    self.alpha = reverse ? 1.0 : 0;
    [UIView animateWithDuration:0.1
                     animations:^{self.alpha = reverse ? 0 : 1.0;}];
    
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            completion();
        });        
    }
    
    self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.05],
                              [NSNumber numberWithFloat:0.95],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = animDuration;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.speed = reverse ? -1 : 1.;
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
    self.layer.transform = CATransform3DIdentity;
}

@end

@implementation MBActionSheetViewItem
@end

@implementation MBActionSheetViewTouchInterceptView

-(id) initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor clearColor];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor clearColor];
}

@end

