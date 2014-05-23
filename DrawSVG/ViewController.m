//
//  ViewController.m
//  DrawSVG
//
//  Created by maneesh yadav on 23/05/14.
//  Copyright (c) 2014 maneesh yadav. All rights reserved.
//

#import "ViewController.h"
#import "DrawingView.h"

@interface ViewController ()
{
    IBOutlet DrawingView *drawingView;
}
-(IBAction)reset:(id)sender;
-(IBAction)save:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [drawingView initializeView];
    drawingView.sizeOfline=10.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)reset:(id)sender
{
    [drawingView clearView];
}

-(IBAction)save:(id)sender
{
    // Saves SVG file to document Directory
    
    [drawingView createSVGFile];
}

@end
