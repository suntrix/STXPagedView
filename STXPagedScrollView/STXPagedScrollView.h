//
//  STXPagedScrollView.h
//  STXPagedScrollView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedScrollView project.
//  Project home page: https://github.com/suntrix/STXPagedScrollView
//

#import <UIKit/UIKit.h>

#import "STXPagedScrollViewPage.h"

@protocol STXPagedScrollViewDelegate;
@protocol STXPagedScrollViewDataSource;

@interface STXPagedScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic) id<STXPagedScrollViewDelegate> delegate;

@property (nonatomic) id<STXPagedScrollViewDataSource> dataSource;

@property (nonatomic) NSInteger currentElementIndex;

@property (nonatomic, readonly) NSInteger numberOfElements;

- (void)reloadData;

- (NSInteger)indexOfPage:(STXPagedScrollViewPage *)cell;

- (STXPagedScrollViewPage *)pageAtIndex:(NSInteger)index;

- (void)scrollToElementAtIndex:(NSInteger)index animated:(BOOL)animated;

- (STXPagedScrollViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier;

@end


@protocol STXPagedScrollViewDataSource <NSObject>

- (NSInteger)numberOfElementsInPagedScrollView:(STXPagedScrollView *)pagedScrollView;

- (STXPagedScrollViewPage *)pagedScrollView:(STXPagedScrollView *)pagedScrollView pageForElementAtIndex:(NSInteger)index;

@end


@protocol STXPagedScrollViewDelegate <NSObject>

@optional

- (void)pagedScrollView:(STXPagedScrollView *)pagedScrollView willDisplayPage:(STXPagedScrollViewPage *)page forElementAtIndex:(NSInteger)index;
- (void)pagedScrollView:(STXPagedScrollView *)pagedScrollView didEndDisplayingPage:(STXPagedScrollViewPage *)page forElementAtIndex:(NSInteger)index;

- (void)pagedScrollViewDidEndDecelerating:(STXPagedScrollView *)pagedScrollView;

@end
