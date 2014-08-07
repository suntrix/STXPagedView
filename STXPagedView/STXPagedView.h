//
//  STXPagedView.h
//  STXPagedView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedView project.
//  Project home page: https://github.com/suntrix/STXPagedView
//

#import <UIKit/UIKit.h>

#import "STXPagedViewPage.h"

@protocol STXPagedViewDataSource;
@protocol STXPagedViewDelegate;

@interface STXPagedView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic) id<STXPagedViewDataSource> dataSource;
@property (nonatomic) id<STXPagedViewDelegate> delegate;

@property (nonatomic) NSInteger currentElementIndex;

@property (nonatomic, readonly) NSInteger numberOfElements;

- (void)reloadData;

- (NSInteger)indexOfPage:(STXPagedViewPage *)page;

- (STXPagedViewPage *)pageAtIndex:(NSInteger)index;

- (void)scrollToElementAtIndex:(NSInteger)index animated:(BOOL)animated;

- (STXPagedViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier;

@end


@protocol STXPagedViewDataSource <NSObject>

- (NSInteger)numberOfElementsInPagedView:(STXPagedView *)pagedView;

- (STXPagedViewPage *)pagedView:(STXPagedView *)pagedView pageForElementAtIndex:(NSInteger)index;

@end


@protocol STXPagedViewDelegate <NSObject>

@optional

- (void)pagedView:(STXPagedView *)pagedView willDisplayPage:(STXPagedViewPage *)page forElementAtIndex:(NSInteger)index;
- (void)pagedView:(STXPagedView *)pagedView didEndDisplayingPage:(STXPagedViewPage *)page forElementAtIndex:(NSInteger)index;

- (void)pagedViewDidEndDecelerating:(STXPagedView *)pagedView;

@end
