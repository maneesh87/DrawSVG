DrawSVG
=======

Custom UIImageview which supports drawing and creation of SVG image files. Ideal for creating and storing signatures in SVG format.

## Getting Started

SVGDrawingView can be directly added as a view to storyboard or added as subview.

### Setup
```objective-c
// Set Color:
drawingView.strokeColor = [UIColor darkGrayColor];

// Set Width:
drawingView.strokeWidth = 10.0;
```

### Save SVG file to document directory:
```objective-c
NSString *path = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/Sign.svg"];
NSError *e;
[drawingView saveSVGFileToPath:path error:&e];
```

### Get SVG file as string:
```objective-c
[drawingView getSVGString];
```

### Reset View:
```objective-c
[drawingView clearView];
```

For more details check the xcode project.
