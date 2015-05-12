//
//  CustomOverlayView.m
//  BaiduMapDrawerDemo
//
//  Created by Jinsongzhuang on 5/11/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import "CustomOverlayView.h"
#import <BaiduMapAPI/BMKPolyline.h>
#import <BaiduMapAPI/BMKPolygon.h>
#import "CustomMapDefine.h"

@implementation CustomOverlayView

- (id)initWithCustomOverlay:(id)overlay
{
    _customOverlay = overlay;
    self = [super initWithOverlay:overlay];
    return self;
}

- (void)glRender
{
    if ([_customOverlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolyline *lineOverlay = _customOverlay;
        
        [self renderLinesWithPoints:lineOverlay.points pointCount:lineOverlay.pointCount strokeColor:OutLineColor lineWidth:OutLineWidth looped:NO lineDash:NO];
        
        [self renderLinesWithPoints:lineOverlay.points pointCount:lineOverlay.pointCount strokeColor:InnerLineColor lineWidth:InnerLineWidth looped:NO lineDash:NO];

        
        return;
    }
    else if ([_customOverlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygon *polygon = _customOverlay;
        
        [self renderLinesWithPoints:polygon.points pointCount:polygon.pointCount strokeColor:AreaLineColor lineWidth:AreaLineWidth looped:YES lineDash:NO];
        [self renderATRegionWithPoint:polygon.points pointCount:polygon.pointCount fillColor:AreafillColor usingTriangleFan:YES];
        
        return;
    }
}

@end
