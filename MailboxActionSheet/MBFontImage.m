
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

#define MBFontImage_iconColor [UIColor colorWithWhite:0.9 alpha:1]

+(UIImage*) info {
    return [self entypoIconChar:95];
}

+(UIImage*) like {
    return [self entypoIconChar:56];
}

+(UIImage*) search {
    return [self entypoIconChar:244];
}

+(UIImage*) star {
    return [self entypoIconChar:55];
}

+(UIImage*) share {
    return [self entypoIconChar:47];
}

+(UIImage*) up {
    return [self entypoIconChar:227];
}

+(UIImage*) down {
    return [self entypoIconChar:228];
}

+(UIImage*) mail {
    return [self entypoIconChar:37];
}

+(UIImage*) later {
    return [self entypoIconChar:78];
}


+(UIImage*) more {
    return [self entypoIconChar:246];
}

+(UIImage*) entypoIconChar:(unichar)charNumber
{
    NSString *icon = [NSString stringWithCharacters:&charNumber length:1];
    return [self imageFromText:icon
                          size:80
                         color:MBFontImage_iconColor
                      fontName:@"Entypo"
                        shadow:NO
                        insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


#pragma mark - Text drawing


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
            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0.0), 1.0, [[UIColor colorWithWhite:0 alpha:1] CGColor]);
        }
        [text drawAtPoint:CGPointMake(insets.left, insets.top) withFont:font];
        
        // transfer image
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[self sharedCache] setObject:image forKey:key];
    }
    
    return image;
}



@end