//
//  ServiceTrafficView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/10.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "ServiceEntity.h"

@protocol ServiceTrafficViewDelegate;

@interface ServiceTrafficView : TempletView<UIScrollViewDelegate>

@property (weak,nonatomic)   id<ServiceTrafficViewDelegate>      delegate;

- (void)getServiceTrafficWithString:(NSString *)trafficUrl;

@end

@protocol ServiceTrafficViewDelegate <NSObject>

- (void)serviceTrafficView:(ServiceTrafficView *)serviceTrafficView didStartDragScrollView:(UIScrollView *)scrollView;

@end