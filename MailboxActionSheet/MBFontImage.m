
#import "MBFontImage.h"

@implementation MBFontImage

+ (MBFontImage *)sharedFontImage {
    static MBFontImage *_sharedFontImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFontImage = [[MBFontImage alloc] init];
    });
    
    return _sharedFontImage;
}


+ (NSCache *)sharedCache {
    static NSCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[NSCache alloc] init];
    });
    
    return _sharedCache;
}

+(UIImage *)imageFromText:(NSString *)text
                     size:(CGFloat)pointSize
                    color:(UIColor*)color
                 fontName:(NSString*)fontName
                   shadow:(BOOL)shadow
{
    return [self imageFromText:text size:pointSize color:color fontName:fontName shadow:shadow insets:UIEdgeInsetsZero];
}

+(UIImage *)imageFromText:(NSString *)text
                     size:(CGFloat)pointSize
                    color:(UIColor*)color
                 fontName:(NSString*)fontName
                   shadow:(BOOL)shadow
                   insets:(UIEdgeInsets)insets
{
    CGFloat r,g,b,a,w=0;
    if(![color getRed:&r green:&g blue:&b alpha:&a]) {
        [color getWhite:&w alpha:&a];
    }
    NSString *colorString = [NSString stringWithFormat:@"%.2f%.2f%.2f%.2f%.2f",w,r,g,b,a];
    NSString* key = [NSString stringWithFormat:@"%@-%.0f-%@-%@-%d",text,pointSize,colorString,fontName,shadow];
    UIImage *image = [[self sharedCache] objectForKey:key];
    if(!image) {
    
        UIFont *font = [UIFont fontWithName:fontName size:pointSize];
        CGSize size  = [text sizeWithFont:font];
        size.height += insets.bottom;
        size.height += insets.top;
        size.width += insets.right;
        size.width += insets.left;
        
        if (UIGraphicsBeginImageContextWithOptions != NULL)
            UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
        else
            UIGraphicsBeginImageContext(size);
                
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx,[color CGColor]);
        if (shadow) {
            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0, [[UIColor colorWithRed:0. green:0 blue:0 alpha:1.] CGColor]);
        }
        [text drawAtPoint:CGPointMake(insets.left, insets.top) withFont:font];
        
        // transfer image
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[self sharedCache] setObject:image forKey:key];
    }
    
    return image;
}


+(UIImage*) info
{
    unichar aChar = 95;
    NSString *icon = [NSString stringWithCharacters:&aChar length:1];
    return [self imageFromText:icon
                          size:100
                         color:[UIColor whiteColor]
                      fontName:@"Entypo"
                        shadow:YES
                        insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+(UIImage*) more
{
    unichar aChar = 246;
    NSString *icon = [NSString stringWithCharacters:&aChar length:1];
    return [self imageFromText:icon
                          size:100
                         color:[UIColor whiteColor]
                      fontName:@"Entypo"
                        shadow:NO
                        insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}



//+(MBButton*) buttonWithIconChar:(unichar)aChar
//                       fontName:(NSString*)fontName
//                       fontSize:(NSInteger)fontSize
//                contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
//                         target:(id)target
//                       selector:(SEL)selector
//{
//    MBButton *button = [MBButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    
//    NSString *icon = [NSString  stringWithCharacters:&aChar length:1];
//    [button setTitle:icon forState:UIControlStateNormal];    
//    button.contentEdgeInsets = contentEdgeInsets;
//    button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
//    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    button.exclusiveTouch = YES;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    button.titleLabel.shadowOffset = CGSizeMake(0., 1.);
//    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.frame = (CGRect){.origin=CGPointZero,.size={40,40.}};
//    return button;
//}


@end