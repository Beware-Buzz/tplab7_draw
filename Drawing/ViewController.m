//
//  ViewController.m
//  Drawing
//
//  Created by Admin on 07.05.16.
//  Copyright © 2016 SmallTownGayBar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UIImageView *canvas;
@property CGPoint lastPoint;







@end

@implementation ViewController{
    CGPoint _lastPoint;
    BOOL _experimentalStroke;
}

-(void)setBorders{
    self.canvas.layer.borderWidth = 0.5f;
    self.canvas.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [self setLastPoint:[touch locationInView: self.view]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.canvas];
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    CGRect drawRect = CGRectMake(0.0f, 0.0f, self.canvas.frame.size.width, self.canvas.frame.size.height);
    [[self.canvas image] drawInRect:drawRect];
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    if (_experimentalStroke) {
        CGPathRef copiedPath = CGContextCopyPath(UIGraphicsGetCurrentContext());
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [_widthSlider value] + 1.0f);
        CGContextSetRGBStrokeColor (UIGraphicsGetCurrentContext(), [_redSlider value], [_greenSlider value], [_blueSlider value], [_alphaSlider value]);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        CGContextAddPath(UIGraphicsGetCurrentContext(), copiedPath);
    }
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [_widthSlider value]);
    CGContextSetRGBStrokeColor (UIGraphicsGetCurrentContext(), [_redSlider value], [_greenSlider value], [_blueSlider value], [_alphaSlider value]);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    self.canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lastPoint = currentPoint;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBorders];
    _experimentalStroke = NO;
    [_widthSlider setMinimumValue:1.0f];
    [_widthSlider setMaximumValue:20.0f];
    [_widthSlider setValue:5.0f];
    [_redSlider setMinimumValue:0.0f];
    [_redSlider setMaximumValue:1.0f];
    [_redSlider setValue:0.5f];
    [_greenSlider setMinimumValue:0.0f];
    [_greenSlider setMaximumValue:1.0f];
    [_greenSlider setValue:0.5f];
    [_alphaSlider setMinimumValue:0.0f];
    [_alphaSlider setMaximumValue:1.0f];
    [_alphaSlider setValue:1.0f];
    [_blueSlider setMinimumValue:0.0f];
    [_blueSlider setMaximumValue:1.0f];
    [_blueSlider setValue:0.5f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)saveButtonTouched:(id)sender {
    if (self.canvas.image == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Image is empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSData *pngData = UIImagePNGRepresentation(self.canvas.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    if ([pngData writeToFile:filePath atomically:YES]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Image was saved!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Image was not saved!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)clearButtonTouched:(id)sender {
    self.canvas.image = nil;
}



@end