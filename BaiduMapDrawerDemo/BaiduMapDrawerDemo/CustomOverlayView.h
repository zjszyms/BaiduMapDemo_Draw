//
//  CustomOverlayView.h
//  BaiduMapDrawerDemo
//
//  Created by Jinsongzhuang on 5/11/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import <BaiduMapAPI/BMKOverlayGLBasicView.h>

@interface CustomOverlayView : BMKOverlayGLBasicView

- (id)initWithCustomOverlay:(id)overlay;

@property (nonatomic, strong) id customOverlay;

@end
