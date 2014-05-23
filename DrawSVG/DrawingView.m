//
//  DrawingView.m
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import "DrawingView.h"


CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    
}


@implementation DrawingView

@synthesize sizeOfline;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   
}


-(void)initializeView
{
    mouseMoved=0;
    arrayOfCoordinates = [[NSMutableArray alloc] init];
    arrayOfPoints=[[NSMutableArray alloc] init];
    
}

-(void)clearView
{
    self.image=nil;
    [arrayOfCoordinates removeAllObjects];
    [arrayOfPoints removeAllObjects];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];

	mouseSwiped = NO;

    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    currentCoordinates = [[NSMutableString alloc] init];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];

	
	
	NSLog(@"moved");
	mouseSwiped = YES;
	        
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2); 
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, [[UIScreen mainScreen] scale]);    

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        
    if (mouseMoved==0) {
        [currentCoordinates appendFormat:@"M %f %f Q %f,%f %f,%f",mid1.x, mid1.y,previousPoint1.x, previousPoint1.y, mid2.x, mid2.y];
        mouseMoved=1;
    }
    else
    {
        [currentCoordinates appendFormat:@"Q %f,%f %f,%f",previousPoint1.x, previousPoint1.y, mid2.x, mid2.y];
    }
    
    NSLog(@"points %f %f, %f %f, %f %f",mid1.x, mid1.y,previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, sizeOfline);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
			

	if(!mouseSwiped) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);    
		[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), sizeOfline);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        [arrayOfPoints addObject:[NSString stringWithFormat:@"<g stroke = \"black\" stroke-width = \"1\" fill = \"black\"><circle id = \"pointA\" cx = \"%f\" cy = \"%f\" r = \"%f\"/></g>",currentPoint.x,currentPoint.y,sizeOfline-1]];
        
        
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
                
	}
	
    [arrayOfCoordinates addObject:currentCoordinates];

    mouseMoved=0;
    
}

- (void) createSVGFile
{
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    CGSize viewSize = self.frame.size;
    
    for (int i = 0; i < arrayOfCoordinates.count; i++)
    {
                
        NSString *st = [NSString stringWithFormat:@"<path stroke = \"black\" stroke-linecap=\"round\" stroke-width = \"%f\" fill = \"none\" d=\"%@\"/>",sizeOfline,[arrayOfCoordinates objectAtIndex:i]];
        [mutStr appendFormat:@"%@",st];
        
    }
    
    for (int i=0; i<arrayOfPoints.count; i++) {
        [mutStr appendFormat:@"%@",[arrayOfPoints objectAtIndex:i]];
    }
    
    NSString *strSVG = [NSString stringWithFormat:@"<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"%f\" height=\"%f\">%@</svg>",viewSize.width,viewSize.height,mutStr];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/Sign.svg"];
    
    NSError *e;
    [strSVG writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&e];
    
    
}







- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
	
//	if ([self pointInside:point withEvent:event]) {
		
		NSLog(@"inside point");
		
		return self; 
//	}
//	return nil;
} 



@end
