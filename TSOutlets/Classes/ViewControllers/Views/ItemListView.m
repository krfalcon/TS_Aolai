//
//  ItemListView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/10.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "ItemListView.h"
#import "MJRefresh.h"

@implementation ItemListView

- (void)initView {
    _page = 0;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width * 5 / 6, self.frame.size.height - self.titleHeight - 60)];
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height + 2)];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setDelegate:self];
    [self addSubview:mainScrollView];
    
    [mainScrollView addHeaderWithTarget:self action:@selector(refresh)];
    
    //side scroll view
    
    UIScrollView *sideView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * 5 / 6, self.titleHeight, self.frame.size.width * 1 / 6, self.frame.size.height - self.titleHeight)];
    [sideView setShowsVerticalScrollIndicator:NO];
    [sideView setDelegate:self];
    [self addSubview:sideView];
    
    NSArray *sideArray = @[@"All",@"Clothes",@"Casual",@"Sport",@"Outdoors",@"Kid",@"Sweater",@"Underwear",@"Shoes",@"Bags",@"Bedding",@"Ornament",@"Makeup",@"Cooking",@"Food"];
    
    NSArray *catagoryArray = @[@"7",@"9",@"10",@"39",@"8",@"11",@"14",@"12",@"13",@"15",@"40",@"16",@"42",@"41",@"17"];
    float h = 10;
    //int i = 7;
    //NSLog(@"%f", sideView.frame.size.height);
    
    for (int i=0;i<catagoryArray.count;i++) {
        
        [sideView addSubview:[self createCategoryButtonWithFrame:CGRectMake(0, h, sideView.frame.size.width, 50 * self.scale) andCategoryType:sideArray[i] andTag:[catagoryArray[i] intValue]]];
        
        h += 55 * self.scale;
    }
    
    [sideView setContentSize:CGSizeMake(sideView.frame.size.width, h)];
    
    DropDownListView *ddlView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, self.titleHeight, 100, 60) andSelections:3 andColor:ThemeBlue];
    [ddlView setDelegate:self];
    [self addSubview:ddlView];
    
    searchView = [[SearchTextView alloc] initWithFrame:CGRectMake(110, self.titleHeight, mainScrollView.frame.size.width - 115, 60) andColor:ThemeBlue_123_204_225];
    [searchView setDelegate:self];
    [self addSubview:searchView];
}

- (void)refresh {
    if (_delegate && [_delegate respondsToSelector:@selector(itemListViewDidRefresh)]) {
        [_delegate itemListViewDidRefresh];
    }
}

- (void)refreshSelf {
    [mainScrollView headerEndRefreshing];
    
    [self resetListScrollView];
}

- (void)resetListScrollView {
    _page = 0;
    
    for (id d in mainScrollView.subviews) {
        if (![d isMemberOfClass:[MJRefreshHeaderView class]]) [d removeFromSuperview];
    }
    
//    [[mainScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.frame.size.width, 2 * self.scale)];
//    [bottomLine setImage:[UIImage imageNamed:@"ShopListLine"]];
//    [mainScrollView addSubview:bottomLine];
    
    [self addListButton];
}

- (void)addListButton {
    if (_itemListArray.count == 0) return;
    
    if (_page * 10 + 10 < _itemListArray.count) {
        for (int i = 0; i < 10; i++) {
            ItemEntity *ety = (ItemEntity *)[_itemListArray objectAtIndex:i + _page * 10];
            [mainScrollView addSubview:[self createListButtonWithItemEntity:ety andTag:i + _page * 10]];
        }
        
        _page += 1;
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, _page * 1600 * self.scale)];
    } else if (_page * 10 < _itemListArray.count) {
        for (int i = _page * 10; i < _itemListArray.count; i++) {
            ItemEntity *ety = (ItemEntity *)_itemListArray[i];
            [mainScrollView addSubview:[self createListButtonWithItemEntity:ety andTag:i]];
        }
        
        _page += 1;
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, _itemListArray.count / 2 * 300 * self.scale + 120 * self.scale > mainScrollView.frame.size.height ? _itemListArray.count / 2 * 300 * self.scale + 300 * self.scale : mainScrollView.frame.size.height + 50 * self.scale)];
    } else {
        return;
    }
}

- (UIView *)createListButtonWithItemEntity:(ItemEntity *)entity andTag:(int)tag {
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(155 * (tag % 2) * self.scale, 300 * (tag / 2) * self.scale, 155 * self.scale, 300 * self.scale)];
    if (searchScrollView) {
        itemView = [[UIView alloc] initWithFrame:CGRectMake(187.5 * (tag % 2) * self.scale + 15 * self.scale, 300 * (tag / 2) * self.scale, 155 * self.scale, 300 * self.scale)];
    }
        
    MDIncrementalImageView *itemImage = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(10 * self.scale, 42.5 * self.scale, 140 * self.scale, 170.6f * self.scale)];
    [itemImage setImageUrl:[NSURL URLWithString:entity.listImageUrl]];
    [itemView addSubview:itemImage];
    
    UILabel *itemName = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.scale, 215 * self.scale, itemImage.frame.size.width, 20 * self.scale)];
    [itemName setText:entity.title];
    [itemName setTextColor:ThemeBlue];
    [itemName setTextAlignment:NSTextAlignmentCenter];
    [itemName setFont:[UIFont systemFontOfSize:16 * self.scale]];
    [itemView addSubview:itemName];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10 * self.scale, 20 * self.scale, 140 * self.scale, 45 * self.scale)];
    titleView.layer.cornerRadius = 22.5 * self.scale;
    [titleView setBackgroundColor:ThemeBlue];
    [itemView addSubview:titleView];
    
    UILabel *chName = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * self.scale, titleView.frame.size.width, 20 * self.scale)];
    [chName setText:entity.shopEntity.chName];
    [chName setTextColor:AbsoluteWhite];
    [chName setTextAlignment:NSTextAlignmentCenter];
    [chName setFont:[UIFont systemFontOfSize:20 * self.scale]];
    [titleView addSubview:chName];
    
    UILabel *enName = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 * self.scale, titleView.frame.size.width, 15 * self.scale)];
    [enName setText:entity.shopEntity.enName];
    [enName setTextColor:AbsoluteWhite];
    [enName setTextAlignment:NSTextAlignmentCenter];
    [enName setFont:[UIFont systemFontOfSize:15 * self.scale]];
    [titleView addSubview:enName];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10 * self.scale, 42.5 * self.scale, 0.5, 210 * self.scale)];
    [leftView setBackgroundColor:ThemeBlue];
    [itemView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(150 * self.scale - 0.5, 42.5 * self.scale, 0.5, 212.5 * self.scale)];
    [rightView setBackgroundColor:ThemeBlue];
    [itemView addSubview:rightView];
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(30 * self.scale, 245 * self.scale, 120 * self.scale, 20 * self.scale)];
    priceView.layer.cornerRadius = 10 * self.scale;
    priceView.backgroundColor = ThemeBlue_177_231_255;
    [itemView addSubview:priceView];
    
    NSString *timeString = [NSString stringWithFormat:@"￥%@", entity.price];
    NSMutableAttributedString *priceStr;
    priceStr = [[NSMutableAttributedString alloc] initWithString:timeString];
    [priceStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, entity.price.length)];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 * self.scale, 0 * self.scale, priceView.frame.size.width - 5 * self.scale, 20 * self.scale)];
    [priceLabel setBackgroundColor:AbsoluteClear];
    [priceLabel setAttributedText:priceStr];
    [priceLabel setTextColor:ThemeBlue_123_204_225];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    [priceLabel setFont:[UIFont systemFontOfSize:14 * self.scale]];
    [priceView addSubview:priceLabel];
    
    UIView *saleView = [[UIView alloc] initWithFrame:CGRectMake(10 * self.scale, 240 * self.scale, 85 * self.scale, 25 * self.scale)];
    saleView.layer.cornerRadius = 12.5 * self.scale;
    saleView.backgroundColor = ThemeBlue;
    [itemView addSubview:saleView];
    
    UILabel *saleLabel = [[UILabel alloc] initWithFrame:saleView.bounds];
    [saleLabel setBackgroundColor:AbsoluteClear];
    [saleLabel setText:[NSString stringWithFormat:@"￥%@", entity.sale]];
    [saleLabel setTextColor:AbsoluteWhite];
    [saleLabel setTextAlignment:NSTextAlignmentCenter];
    [saleLabel setFont:[UIFont systemFontOfSize:20 * self.scale]];
    [saleView addSubview:saleLabel];
    
    UIButton *itemButton = [[UIButton alloc] initWithFrame:itemView.bounds];
    [itemButton setExclusiveTouch:YES];
    [itemButton setTag:tag];
    [itemButton addTarget:self action:@selector(tappedItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:itemButton];
    
    return itemView;
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
    if (_itemSearchArray.count == 0) return;
    
    if (_searchpage * 10 + 10 < _itemSearchArray.count) {
        for (int i = 0; i < 10; i++) {
            ItemEntity *ety = (ItemEntity *)[_itemSearchArray objectAtIndex:i + _searchpage * 10];
            [searchScrollView addSubview:[self createListButtonWithItemEntity:ety andTag:i + _searchpage * 10]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _searchpage * 1500)];
    } else if (_searchpage * 10 < _itemSearchArray.count) {
        for (int i = _searchpage * 10; i < _itemSearchArray.count; i++) {
            ItemEntity *ety = (ItemEntity *)[_itemSearchArray objectAtIndex:i];
            [searchScrollView addSubview:[self createListButtonWithItemEntity:ety andTag:i]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _itemSearchArray.count / 2 * 300 + 380)];
    } else {
        return;
    }
}

#pragma mark - Category

- (UIView *)createCategoryButtonWithFrame:(CGRect)frame andCategoryType:(NSString *)type andTag:(int)tag {
    UIView *categoryView = [[UIView alloc] initWithFrame:frame];
    
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:categoryView.bounds];
    [categoryButton setTag:tag];
    [categoryButton setExclusiveTouch:YES];
    [categoryButton addTarget:self action:@selector(tappedCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:categoryButton];
    
    UIImageView *categoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_NotSelected", type]]];
    [categoryImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height *0.65)];
    [categoryImage setContentMode:UIViewContentModeScaleAspectFit];
    [categoryImage setCenter:CGPointMake(categoryView.frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    [categoryButton addSubview:categoryImage];
    
    UIView *categoryCover = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width + frame.size.height, frame.size.height)];
    categoryCover.layer.cornerRadius = frame.size.height / 2;
    [categoryCover setClipsToBounds:YES];
    [categoryCover setBackgroundColor:ThemeBlue];
    [categoryCover setTag:-999];
    [categoryView addSubview:categoryCover];
    
    UIImageView *categoryCoverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected", type]]];
    [categoryCoverImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.65)];
    [categoryCoverImage setContentMode:UIViewContentModeScaleAspectFit];
    [categoryCoverImage setTag:-998];
    [categoryCoverImage setCenter:CGPointMake(- frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    [categoryCover addSubview:categoryCoverImage];
    
    if ([type isEqualToString:@"All"]) {
        [categoryCover setTag:-997];
        [categoryCover setFrame:CGRectMake(0, 0, frame.size.width + frame.size.height, frame.size.height)];
        
        [categoryCoverImage setCenter:CGPointMake(frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    }
    
    return categoryView;
}


#pragma mark - Button Events

- (void)tappedItemButton:(UIButton *)sender {
    ItemEntity *ety;
    if ([[[sender superview] superview] isEqual:mainScrollView]) {
        ety = [_itemListArray objectAtIndex:sender.tag];
    } else {
        ety = [_itemSearchArray objectAtIndex:sender.tag];
    }
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didTapItemButtonWithItemEntity:)]) {
        [_delegate itemListView:self didTapItemButtonWithItemEntity:ety];
    }
}

- (void)tappedCategoryButton:(UIButton *)sender {
    UIView *hideOuter = [sender.superview.superview viewWithTag:-997];
    [hideOuter setTag:-999];
    UIView *hideInner = [hideOuter viewWithTag:-998];
    
    UIView *showOuter = [sender.superview viewWithTag:-999];
    [showOuter setTag:-997];
    UIView *showInner = [showOuter viewWithTag:-998];
    
    float distance = showInner.frame.size.width;
    
    [UIView animateWithDuration:0.4f animations:^{
        [hideOuter setCenter:CGPointMake(hideOuter.center.x + distance, hideOuter.center.y)];
        [hideInner setCenter:CGPointMake(- distance / 2 + 2 * self.scale, 25 * self.scale)];
        [showOuter setFrame:CGRectMake(0, 0, showOuter.frame.size.width, showOuter.frame.size.height)];
        [showInner setCenter:CGPointMake(distance / 2 + 2 * self.scale, 25 * self.scale)];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didTapCategoryButtonWithCategory:)]) {
        if (sender.tag != 7) {
            [_delegate itemListView:self didTapCategoryButtonWithCategory:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
        } else {
            [_delegate itemListView:self didTapCategoryButtonWithCategory:@""];
        }
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //瀑布流显示
    if ([scrollView isEqual:mainScrollView]) {
        if (mainScrollView.contentSize.height - mainScrollView.contentOffset.y < mainScrollView.frame.size.height * 2) {
            [self addListButton];
        }
    } else if ([scrollView isEqual:searchScrollView]) {
        if (searchScrollView.contentSize.height - searchScrollView.contentOffset.y < searchScrollView.frame.size.height * 2) {
            [self addSearchButton];
        }
    }
}

#pragma mark - Search Delegate

- (void)searchTextView:(SearchTextView *)searchTextView didChange:(NSString *)searchText
{
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didSearch:)]) {
        [_delegate itemListView:self didSearch:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didStartTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didStartTexting:)]) {
        [_delegate itemListView:self didStartTexting:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didEndTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didEndTexting:)]) {
        [_delegate itemListView:self didEndTexting:searchText];
    }
}

#pragma mark - DDL Delegate

- (void)dropDownListView:(DropDownListView *)dropDownListView didTapOption:(SortType)option {
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(itemListView:didTapDropDownListOption:)]) {
        [_delegate itemListView:self didTapDropDownListOption:option];
    }
}

@end
