//
//  ServiceInfoView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/10.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "ServiceEntity.h"

@protocol ServiceInfoViewDelegate;

@interface ServiceInfoView : TempletView<UIScrollViewDelegate>

@property (weak,nonatomic)   id<ServiceInfoViewDelegate>      delegate;

- (void)getServiceInfoWithString:(NSString *)introUrl;

@end

@protocol ServiceInfoViewDelegate <NSObject>

- (void)serviceInfoView:(ServiceInfoView *)serviceInfoView didStartDragScrollView:(UIScrollView *)scrollView;

@end
