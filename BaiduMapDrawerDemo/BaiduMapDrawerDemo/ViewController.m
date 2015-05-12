//
//  ViewController.m
//  BaiduMapDrawerDemo
//
//  Created by Jinsongzhuang on 4/28/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MapCoverView.h"
#import "CustomOverlayView.h"

#import "CustomMapDefine.h"

@interface ViewController ()<BMKMapViewDelegate,MapCoverViewDelegate,UIAlertViewDelegate>

@end

@implementation ViewController
{
    BMKMapView *_mapView;
    NSMutableArray *_coordinates;
    MapCoverView *_canvasView;
    
    NSMutableArray *_overlays;
    
    BMKPointAnnotation *_annotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coordinates = [NSMutableArray array];
    _overlays = [NSMutableArray array];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    
    // 绘制页面
    _canvasView = [[MapCoverView alloc] initWithFrame:_mapView.frame];
    _canvasView.userInteractionEnabled = YES;
    _canvasView.delegate = self;
    [self.view addSubview:_canvasView];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    barView.backgroundColor = [UIColor redColor];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, 10, 100, 44)];
    clearButton.backgroundColor = [UIColor greenColor];
    [clearButton setTitle:@"清除清除" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearMapView) forControlEvents:UIControlEventTouchUpInside];
    
    [barView addSubview:clearButton];
    
    [self.view addSubview:barView];
    
    // 测试数据
    [self addAnnotaitionToMapView:_mapView];
    
}

- (void)addAnnotaitionToMapView:(BMKMapView *)mapview
{
//    116.404, 39.915北京
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    [mapview addAnnotation:annotation];
    
}

- (void)clearMapView
{
//    [_coordinates removeAllObjects];
//    _canvasView.image = nil;
    
    [_mapView removeOverlays:_overlays];
    [_overlays removeAllObjects];
    
}

- (void)touchesBegan:(UITouch*)touch
{
    CGPoint location = [touch locationInView:_mapView];
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
    [_coordinates addObject:[NSValue valueWithCGPoint:CGPointMake(coordinate.latitude, coordinate.longitude)]];
}

- (void)touchesMoved:(UITouch*)touch
{
    CGPoint location = [touch locationInView:_mapView];
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
    [_coordinates addObject:[NSValue valueWithCGPoint:CGPointMake(coordinate.latitude, coordinate.longitude)]];
}

- (void)touchesEnded:(UITouch*)touch isColosedArea:(BOOL)isColosedArea
{
    CGPoint location = [touch locationInView:_mapView];
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
    [_coordinates addObject:[NSValue valueWithCGPoint:CGPointMake(coordinate.latitude, coordinate.longitude)]];
    
    if (isColosedArea)
    {
        [self bmkMapDrawArea:_coordinates];
    }
    else
    {
        [self bmkMapDrawLine:_coordinates];
    }
    
    [_coordinates removeAllObjects];
    _canvasView.image = nil;
}

- (void)bmkMapDrawLine:(NSMutableArray *)coordinatesArray
{
    NSInteger numberOfPoints = [coordinatesArray count];
    
    if (numberOfPoints > 2)
    {
        CLLocationCoordinate2D points[numberOfPoints];
        for (NSInteger i = 0; i < numberOfPoints; i++)
        {
            NSValue *tempValue = coordinatesArray[i];
            
            CLLocationDegrees latitude = tempValue.CGPointValue.x;
            CLLocationDegrees longitude = tempValue.CGPointValue.y;
            
            points[i] = CLLocationCoordinate2DMake(latitude, longitude);
            
        }
        
        [_mapView addOverlay:[BMKPolyline polylineWithCoordinates:points count:numberOfPoints]];
    }
}

- (void)bmkMapDrawArea:(NSMutableArray *)coordinatesArray
{
    NSInteger numberOfPoints = [coordinatesArray count];
    if (numberOfPoints > 2)
    {
        CLLocationCoordinate2D points[numberOfPoints];
        for (NSInteger i = 0; i < numberOfPoints; i++)
        {
            NSValue *tempValue = coordinatesArray[i];

            CLLocationDegrees latitude = tempValue.CGPointValue.x;
            CLLocationDegrees longitude = tempValue.CGPointValue.y;

            points[i] = CLLocationCoordinate2DMake(latitude, longitude);

        }

        [_mapView addOverlay:[BMKPolygon polygonWithCoordinates:points count:numberOfPoints]];
    }
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    CustomOverlayView *customOverlayView = [[CustomOverlayView alloc] initWithCustomOverlay:overlay];
    
    NSString *alertString = @"";
    
    if ([self mapViewContainsPoint:customOverlayView.customOverlay]) {
        NSLog(@"在区域内");
        alertString = @"在区域内";
    }
    else
    {
        NSLog(@"不在区域内");
        
        alertString = @"不在区域内";
    }
    
    // 保存overlay列表，移除时使用
    [_overlays addObject:overlay];
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertString delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
    
    return customOverlayView;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clearMapView];
}


- (BOOL)mapViewContainsPoint:(id)customOverlay
{
    if ([customOverlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygon *polygon = customOverlay;
        
        BOOL isIn = BMKPolygonContainsPoint(BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915, 116.404)), polygon.points, polygon.pointCount);
        
        if (isIn) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([customOverlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolyline *polyline = customOverlay;
        
        BMKMapPoint tempPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915, 116.404));
        BMKMapPoint linePoint = BMKGetNearestMapPointFromPolyline(tempPoint, polyline.points, polyline.pointCount);
        
        CGPoint mapViewPoint1 = [_mapView convertCoordinate:BMKCoordinateForMapPoint(tempPoint) toPointToView:_mapView];
        CGPoint mapViewPoint2 = [_mapView convertCoordinate:BMKCoordinateForMapPoint(linePoint) toPointToView:_mapView];
        
        if ([self distanceBetweenPoints:mapViewPoint1 endPoint:mapViewPoint2] <= OutLineWidth/2.0) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


- (float)distanceBetweenPoints:(CGPoint)beginPoint endPoint:(CGPoint)endPoint
{
    float x = fabs(beginPoint.x - endPoint.x);
    float y = fabs(beginPoint.y - endPoint.y);
    return sqrtf(x*x+y*y);
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


@end
