//
//  SVGDrawingView.m
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import "SVGDrawingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SVGDrawingView {
    
    BOOL didMove;
    BOOL isMoving;
    
    CGPoint lastPoint;
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    NSMutableString *currentCoordinates;
    NSMutableArray *arrayOfCoordinates;
    NSMutableArray *arrayOfPoints;
    
}

@synthesize strokeWidth, strokeColor;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        [self initializeView];
    }
    return self;
    
}

-(void)initializeView {
    
    isMoving=0;
    arrayOfCoordinates = [[NSMutableArray alloc] init];
    arrayOfPoints=[[NSMutableArray alloc] init];
    strokeColor = [UIColor blackColor];
    
}

-(void)clearView {
    
    self.image=nil;
    [arrayOfCoordinates removeAllObjects];
    [arrayOfPoints removeAllObjects];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    didMove = NO;
    
    UITouch *touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    currentCoordinates = [[NSMutableString alloc] init];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    didMove = YES;
    
    UITouch *touch = [touches anyObject];
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = [self midPoint:previousPoint1 point2:previousPoint2];
    CGPoint mid2 = [self midPoint:currentPoint point2:previousPoint1];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    if (isMoving == 0) {
        [currentCoordinates appendFormat:@"M %f %f Q %f,%f %f,%f",mid1.x, mid1.y,previousPoint1.x, previousPoint1.y, mid2.x, mid2.y];
        isMoving=1;
    }
    else {
        [currentCoordinates appendFormat:@"Q %f,%f %f,%f",previousPoint1.x, previousPoint1.y, mid2.x, mid2.y];
    }
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, strokeWidth);
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [self.strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!didMove) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
        [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), strokeWidth);
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [self.strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        [arrayOfPoints addObject:[NSString stringWithFormat:@"<g stroke = \"%@\" stroke-width = \"1\" fill = \"%@\"><circle id = \"pointA\" cx = \"%f\" cy = \"%f\" r = \"%f\"/></g>",[self setColor],[self setColor],currentPoint.x,currentPoint.y,strokeWidth-1]];
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [arrayOfCoordinates addObject:currentCoordinates];
    isMoving = 0;
    
}

- (NSString *)setColor {
    
    NSString *hexColor = [self hexStringFromColor:self.strokeColor];
    return hexColor;
    
}


- (NSString *)hexStringFromColor:(UIColor *)color {
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r, g, b, a;
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    } else {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    return self;
    
}

- (CGPoint) midPoint:(CGPoint)p1 point2:(CGPoint)p2 {
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    
}

- (void)saveSVGFileToPath:(NSString *)path error:(NSError **)error {
    
    [[self getSVGString] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
    
}

- (NSString *)getSVGString {
    
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    CGSize viewSize = self.frame.size;
    
    for (int i = 0; i < arrayOfCoordinates.count; i++) {
        NSString *st = [NSString stringWithFormat:@"<path stroke = \"%@\" stroke-linecap=\"round\" stroke-width = \"%f\" fill = \"none\" d=\"%@\"/>",[self setColor],strokeWidth,[arrayOfCoordinates objectAtIndex:i]];
        [mutStr appendFormat:@"%@",st];
    }
    
    for (int i=0; i<arrayOfPoints.count; i++) {
        [mutStr appendFormat:@"%@",[arrayOfPoints objectAtIndex:i]];
    }
    
    NSString *strSVG = [NSString stringWithFormat:@"<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"%f\" height=\"%f\">%@</svg>",viewSize.width,viewSize.height,mutStr];
    
    return strSVG;
    
}

@end
