//
//  DrawingView.h
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

CGPoint midPoint(CGPoint p1, CGPoint p2);

@interface DrawingView : UIImageView
{
    BOOL mouseSwiped;
    CGPoint lastPoint;

    NSMutableString *currentCoordinates;
    NSMutableArray *arrayOfCoordinates;
    NSMutableArray *arrayOfPoints;
    CGFloat sizeOfline;
    
    int mouseMoved;
    
    
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
}
@property(nonatomic)CGFloat sizeOfline;

- (void) createSVGFile;
-(void) initializeView;
-(void)clearView;



@end
