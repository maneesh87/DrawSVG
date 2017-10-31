//
//  SVGDrawingView.h
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGDrawingView : UIImageView {
}

@property(nonatomic) IBInspectable CGFloat strokeWidth;
@property(nonatomic) UIColor *strokeColor;

- (void) saveSVGFileToPath:(NSString *)path error:(NSError **)error;
- (NSString *) getSVGString;
- (void) clearView;

@end
