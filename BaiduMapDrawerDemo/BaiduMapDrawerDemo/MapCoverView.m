//
//  MapCoverView.h
//  BaiduMapDrawerDemo
//
//  Created by Jinsongzhuang on 4/28/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import "MapCoverView.h"
#import "CustomMapDefine.h"

@interface MapCoverView()
@property (nonatomic, assign) CGPoint location;

@property (nonatomic, assign) CGPoint beginLocationPoint;
@property (nonatomic, assign) CGPoint endLocationPoint;

@end

@implementation MapCoverView
@synthesize location = _location;
@synthesize delegate = _delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self.delegate touchesBegan:touch];
    self.location = [touch locationInView:self];
    self.beginLocationPoint = self.location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    [self.delegate touchesMoved:touch];
    
    UIGraphicsBeginImageContext(self.frame.size); 
    CGContextRef ctx = UIGraphicsGetCurrentContext();   
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, DrawLineWidth);
    CGContextSetStrokeColorWithColor(ctx, DrawLineColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    self.endLocationPoint = currentLocation;
    
    
    if ([self distanceBetweenPoints:_beginLocationPoint endPoint:_endLocationPoint] < DrawClosedAreaMinLength)
    {
        [self.delegate touchesEnded:touch isColosedArea:YES];
    }
    else
    {
        [self.delegate touchesEnded:touch isColosedArea:NO];
    }
    
    
    self.location = currentLocation;
}

- (float)distanceBetweenPoints:(CGPoint)beginPoint endPoint:(CGPoint)endPoint
{
    float x = fabs(beginPoint.x - endPoint.x);
    float y = fabs(beginPoint.y - endPoint.y);
    return sqrtf(x*x+y*y);
}

@end
