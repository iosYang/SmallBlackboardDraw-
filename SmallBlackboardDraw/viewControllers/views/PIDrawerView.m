//
//  PIDrawerView.m
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import "PIDrawerView.h"

@interface PIDrawerView ()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
    UIImage *image;
    float lineWidthFloat;

}

@end

@implementation PIDrawerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ImageArray = [[NSMutableArray alloc] init];
    image = [[UIImage alloc] init];
    [self initialize];
    
    lineWidthFloat=4;
}

- (void)drawRect:(CGRect)rect
{
    [self.viewImage drawInRect:self.bounds];
}

#pragma mark - 设置表头宽度
-(void)setLineCapWitdh:(float)lineWidth
{
    lineWidthFloat=lineWidth;
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

#pragma mark - Private methods
- (void)initialize
{
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingMode = DrawingModeNone;
    [self setDrawingMode:DrawingModePaint];

    
    _selectedColor = [UIColor blackColor];
}

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}


- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidthFloat);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    previousPoint = currentPoint;
    
    [self setNeedsDisplay];

}

-(void)getImage{
    
    [self setNeedsDisplay];
}

- (void)handleTouches
{
    if (self.drawingMode == DrawingModeNone) {
        // do nothing
    }
    else if (self.drawingMode == DrawingModePaint) {
        [self drawLineNew];
    }
    else
    {
        [self eraseLine];
    }
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    image = self.viewImage;

    [self handleTouches];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    [_ImageArray addObject:image];
    //NSLog(@"%d",_ImageArray.count);
    [self handleTouches];
    
}

@end
