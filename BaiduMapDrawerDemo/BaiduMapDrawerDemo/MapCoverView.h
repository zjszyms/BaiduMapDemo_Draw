//
//  MapCoverView.h
//  BaiduMapDrawerDemo
//
//  Created by Jinsongzhuang on 4/28/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapCoverViewDelegate;

@interface MapCoverView : UIImageView

@property(nonatomic, weak) id<MapCoverViewDelegate> delegate;

@end

@protocol MapCoverViewDelegate <NSObject>

@required
- (void)touchesBegan:(UITouch*)touch;

- (void)touchesMoved:(UITouch*)touch;

- (void)touchesEnded:(UITouch*)touch isColosedArea:(BOOL)isColosedArea;

@end
