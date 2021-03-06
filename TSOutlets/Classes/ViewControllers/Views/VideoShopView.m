//
//  VideoShopView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/9.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "VideoShopView.h"
#import "MJRefresh.h"

@implementation VideoShopView

- (void)initView {
    _page = 0;
    
    videoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width, self.frame.size.height - self.titleHeight - 60)];
    [videoScrollView setDelegate:self];
    [self addSubview:videoScrollView];
    
    DropDownListView *ddlView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, self.titleHeight, 100, 60) andSelections:2 andColor:ThemeRed];
    [ddlView setDelegate:self];
    [self addSubview:ddlView];
    
    SearchTextView *searchView = [[SearchTextView alloc] initWithFrame:CGRectMake(110, self.titleHeight, self.frame.size.width - 115, 60) andColor:ThemeRed_255_184_194];
    [searchView setDelegate:self];
    [self addSubview:searchView];
    
    [videoScrollView addHeaderWithTarget:self action:@selector(refresh)];
}

- (void)refresh {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopViewDidRefresh)]) {
        [_delegate videoShopViewDidRefresh];
    }
}

- (void)refreshSelf {
    [videoScrollView headerEndRefreshing];
    
    [self createVideoListWithVideoEntityArray];
}

- (void)createVideoListWithVideoEntityArray {
    _page = 0;
    
    for (id d in videoScrollView.subviews) {
        if (![d isMemberOfClass:[MJRefreshHeaderView class]]) [d removeFromSuperview];
    }
    //[[videoScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addListButton];
}

- (void)addListButton {
    if (_page * 10 + 10 < _videoListArray.count) {
        for (int i = 0; i < 10; i++) {
            VideoEntity *ety = (VideoEntity *)[_videoListArray objectAtIndex:i + _page * 10];
            
            [videoScrollView addSubview:[self createListButtonWithFrame:CGRectMake((self.frame.size.width / 2 + 5 * self.scale) * (i % 2), (i / 2) * 180 + _page * 900, (self.frame.size.width - 10 * self.scale) / 2, 160) andVideoEntity:ety andTag:i + _page * 10]];
        }
        
        _page += 1;
        [videoScrollView setContentSize:CGSizeMake(videoScrollView.frame.size.width, _page * 1000)];
    } else if (_page * 10 < _videoListArray.count) {
        for (int i = _page * 10; i < _videoListArray.count; i++) {
            VideoEntity *ety = (VideoEntity *)[_videoListArray objectAtIndex:i];
            [videoScrollView addSubview:[self createListButtonWithFrame:CGRectMake((self.frame.size.width / 2 + 5 * self.scale) * (i % 2), (i / 2) * 180, (self.frame.size.width - 10 * self.scale) / 2, 160) andVideoEntity:ety andTag:i]];
        }
        
        _page += 1;
        [videoScrollView setContentSize:CGSizeMake(videoScrollView.frame.size.width, _videoListArray.count * 75 + 80 > videoScrollView.frame.size.height ? _videoListArray.count * 90 + 80 : videoScrollView.frame.size.height + 1)];
    } else {
        return;
    }
}

- (UIView *)createListButtonWithFrame:(CGRect)frame andVideoEntity:(VideoEntity *)ety andTag:(int)tag {
    UIView *videoView = [[UIView alloc] initWithFrame:frame];
    [videoView setClipsToBounds:YES];
    [videoScrollView addSubview:videoView];
    
    if (frame.origin.x == 0) {
        MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(7.5 * self.scale, 12.5 * self.scale, videoView.frame.size.width - 7.5 * self.scale, (videoView.frame.size.width - 7.5 * self.scale) * 410 / 710 )];
        [imageView setShowLoadingIndicatorWhileLoading:YES];
        [imageView setImageUrl:[NSURL URLWithString:ety.imageUrl]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [videoView addSubview:imageView];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(-25 * self.scale, 0, 175 * self.scale, 25 * self.scale)];
        [titleView.layer setCornerRadius:12.5 * self.scale];
        [titleView setBackgroundColor:ThemeRed];
        [videoView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 0, 150 * self.scale, 25 * self.scale)];
        [titleLabel setBackgroundColor:AbsoluteClear];
        [titleLabel setText:ety.title];
        [titleLabel setTextColor:AbsoluteWhite];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16 * self.scale]];
        [titleView addSubview:titleLabel];
        
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(40 * self.scale, videoView.frame.size.height - 75 * self.scale, videoView.frame.size.width - (40 - 17.5) * self.scale, 35 * self.scale)];
        [nameView.layer setCornerRadius:17.5 * self.scale];
        [nameView setBackgroundColor:ThemeRed];
        [videoView addSubview:nameView];
        
        UILabel *chName = [[UILabel alloc] initWithFrame:CGRectMake(15 * self.scale, 2.5 * self.scale, nameView.frame.size.width - nameView.frame.size.height, 18 * self.scale)];
        [chName setBackgroundColor:AbsoluteClear];
        [chName setText:ety.shopEntity.chName];
        [chName setTextColor:AbsoluteWhite];
        [chName setTextAlignment:NSTextAlignmentRight];
        [chName setFont:[UIFont boldSystemFontOfSize:14 * self.scale]];
        [nameView addSubview:chName];
        
        UILabel *enName = [[UILabel alloc] initWithFrame:CGRectMake(15 * self.scale, 20.5 * self.scale, nameView.frame.size.width - nameView.frame.size.height, 12 * self.scale)];
        [enName setBackgroundColor:AbsoluteClear];
        [enName setText:ety.shopEntity.enName];
        [enName setTextColor:AbsoluteWhite];
        [enName setTextAlignment:NSTextAlignmentRight];
        [enName setFont:[UIFont boldSystemFontOfSize:10 * self.scale]];
        [nameView addSubview:enName];
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(70 * self.scale, videoView.frame.size.height - 40 * self.scale, videoView.frame.size.width - 62.5 * self.scale, 15 * self.scale)];
        timeView.layer.cornerRadius = 7.5 * self.scale;
        [timeView setBackgroundColor:ThemeRed_255_184_194];
        [videoView addSubview:timeView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 * self.scale, 0, timeView.frame.size.width - 12.5 * self.scale, 15 * self.scale)];
        [timeLabel setBackgroundColor:AbsoluteClear];
        [timeLabel setTextColor:ThemeRed_136_028_018];
        [timeLabel setText:ety.time];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont systemFontOfSize:12 * self.scale]];
        [timeView addSubview:timeLabel];
        
    } else {
        MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(0 * self.scale, 12.5 * self.scale, videoView.frame.size.width - 7.5 * self.scale, (videoView.frame.size.width - 7.5 * self.scale) * 410 / 710 )];
        [imageView setShowLoadingIndicatorWhileLoading:YES];
        [imageView setImageUrl:[NSURL URLWithString:ety.imageUrl]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        //[imageView setDelegate:self];
        //[imageView setTag:(int)avc];
        [videoView addSubview:imageView];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(videoView.frame.size.width - 150 * self.scale, 0, 175 * self.scale, 25 * self.scale)];
        [titleView.layer setCornerRadius:12.5 * self.scale];
        [titleView setBackgroundColor:ThemeRed];
        [videoView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 * self.scale, 0, 145 * self.scale, 25 * self.scale)];
        [titleLabel setBackgroundColor:AbsoluteClear];
        [titleLabel setText:ety.title];
        [titleLabel setTextColor:AbsoluteWhite];
        [titleLabel setTextAlignment:NSTextAlignmentRight];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16 * self.scale]];
        [titleView addSubview:titleLabel];
        
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(- 17.5 * self.scale, videoView.frame.size.height - 75 * self.scale, videoView.frame.size.width - (40 - 17.5) * self.scale, 35 * self.scale)];
        [nameView.layer setCornerRadius:17.5 * self.scale];
        [nameView setBackgroundColor:ThemeRed];
        [videoView addSubview:nameView];
        
        UILabel *chName = [[UILabel alloc] initWithFrame:CGRectMake(20 * self.scale, 2.5 * self.scale, nameView.frame.size.width - nameView.frame.size.height, 18 * self.scale)];
        [chName setBackgroundColor:AbsoluteClear];
        [chName setText:ety.shopEntity.chName];
        [chName setTextColor:AbsoluteWhite];
        [chName setTextAlignment:NSTextAlignmentLeft];
        [chName setFont:[UIFont boldSystemFontOfSize:14 * self.scale]];
        [nameView addSubview:chName];
        
        UILabel *enName = [[UILabel alloc] initWithFrame:CGRectMake(20 * self.scale, 20.5 * self.scale, nameView.frame.size.width - nameView.frame.size.height, 12 * self.scale)];
        [enName setBackgroundColor:AbsoluteClear];
        [enName setText:ety.shopEntity.enName];
        [enName setTextColor:AbsoluteWhite];
        [enName setTextAlignment:NSTextAlignmentLeft];
        [enName setFont:[UIFont boldSystemFontOfSize:10 * self.scale]];
        [nameView addSubview:enName];
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(- 7.5 * self.scale, videoView.frame.size.height - 40 * self.scale, videoView.frame.size.width - 62.5 * self.scale, 15 * self.scale)];
        timeView.layer.cornerRadius = 7.5 * self.scale;
        [timeView setBackgroundColor:ThemeRed_255_184_194];
        [videoView addSubview:timeView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5 * self.scale, 0, timeView.frame.size.width - 12.5 * self.scale, 15 * self.scale)];
        [timeLabel setBackgroundColor:AbsoluteClear];
        [timeLabel setTextColor:ThemeRed_136_028_018];
        [timeLabel setText:ety.time];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setFont:[UIFont systemFontOfSize:12 * self.scale]];
        [timeView addSubview:timeLabel];
        
    }
    
    UIButton *videoButton = [[UIButton alloc] initWithFrame:videoView.bounds];
    [videoButton setTag:tag];
    [videoButton setExclusiveTouch:YES];
    [videoButton addTarget:self action:@selector(tappedVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoView addSubview:videoButton];
    
    return videoView;
}

#pragma mark - Search Bar

- (void)addSearchList {
    if (!searchScrollView) {
        
        _searchpage = 0;
        
        searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width, self.frame.size.height - self.titleHeight - 60)];
        [searchScrollView setBackgroundColor:AbsoluteWhite];
        [searchScrollView setShowsVerticalScrollIndicator:NO];
        [searchScrollView setDelegate:self];
        [self addSubview:searchScrollView];
        
    }
}

- (void)removeSearchList {
    [searchScrollView removeFromSuperview];
    searchScrollView  =  nil;
}

- (void)didSearch {
    _searchpage = 0;
    
    [[searchScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, searchScrollView.frame.size.height)];
    
    [self addSearchButton];
}

- (void)addSearchButton {
    if (_videoSearchArray.count == 0) return;
    
    if (_searchpage * 10 + 10 < _videoSearchArray.count) {
        for (int i = 0; i < 10; i++) {
            VideoEntity *ety = (VideoEntity *)[_videoSearchArray objectAtIndex:i + _searchpage * 10];
            
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake((self.frame.size.width / 2 + 5 * self.scale) * (i % 2), (i / 2) * 180 + _searchpage * 900, searchScrollView.frame.size.width, 160) andVideoEntity:ety andTag:i + _searchpage * 10]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _searchpage * 750)];
    } else if (_searchpage * 10 < _videoSearchArray.count) {
        for (int i = _searchpage * 10; i < _videoSearchArray.count; i++) {
            VideoEntity *ety = (VideoEntity *)[_videoSearchArray objectAtIndex:i];
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake((self.frame.size.width / 2 + 5 * self.scale) * (i % 2), (i / 2) * 180, (self.frame.size.width - 10 * self.scale) / 2, 160) andVideoEntity:ety andTag:i]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _videoSearchArray.count * 75 + 80)];
    } else {
        return;
    }
}

- (void)tappedVideoButton:(UIButton *)button {
    VideoEntity *videoEntity;
    if (searchScrollView) {
        videoEntity = (VideoEntity *)[_videoSearchArray objectAtIndex:button.tag];
    } else {
        videoEntity = (VideoEntity *)[_videoListArray objectAtIndex:button.tag];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didPlayerVideo:)]) {
        [_delegate videoShopView:self didPlayerVideo:videoEntity.videoUrl ];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didStartDragScrollView:)]) {
        [_delegate videoShopView:self didStartDragScrollView:scrollView ];
    }
    
    //瀑布流显示
    if ([scrollView isEqual:videoScrollView]) {
        if (videoScrollView.contentSize.height - videoScrollView.contentOffset.y < videoScrollView.frame.size.height * 2) {
            [self addListButton];
        }
    } else if ([scrollView isEqual:searchScrollView]) {
        if (searchScrollView.contentSize.height - searchScrollView.contentOffset.y < searchScrollView.frame.size.height ) {
            [self addSearchButton];
        }
    }
}

#pragma mark - Search Delegate

- (void)searchTextView:(SearchTextView *)searchTextView didChange:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didSearch:)]) {
        [_delegate videoShopView:self didSearch:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didStartTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didStartTexting:)]) {
        [_delegate videoShopView:self didStartTexting:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didEndTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didEndTexting:)]) {
        [_delegate videoShopView:self didEndTexting:searchText];
    }
}

#pragma mark - DDL Delegate

- (void)dropDownListView:(DropDownListView *)dropDownListView didTapOption:(SortType)option {
    if (_delegate && [_delegate respondsToSelector:@selector(videoShopView:didTapDropDownListOption:)]) {
        [_delegate videoShopView:self didTapDropDownListOption:option];
    }
}

@end
