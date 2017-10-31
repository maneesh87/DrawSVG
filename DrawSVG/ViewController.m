//
//  ViewController.m
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import "ViewController.h"
#import "SVGDrawingView.h"

@interface ViewController () {
    IBOutlet SVGDrawingView *drawingView;
}

- (IBAction)reset:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    drawingView.strokeColor = [UIColor darkGrayColor];
    drawingView.strokeWidth = 10.0;
    
}

- (IBAction)reset:(id)sender {
    
    [drawingView clearView];
    
}

- (IBAction)save:(id)sender {
    
    // Saves SVG file to document Directory
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/Sign.svg"];
    NSError *e;
    [drawingView saveSVGFileToPath:path error:&e];
    
}

@end
