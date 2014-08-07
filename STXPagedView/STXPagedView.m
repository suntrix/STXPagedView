//
//  STXPagedView.m
//  STXPagedView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedView project.
//  Project home page: https://github.com/suntrix/STXPagedView
//

#import "STXPagedView.h"

@interface STXPagedView ()

@property (nonatomic, strong) NSMutableDictionary *    _registeredNibs;
@property (nonatomic, strong) NSMutableDictionary *    _registeredClasses;

- (void)__initialSetup;

- (void)__buildPageForCurrentElementIndex;

- (void)__buildPageForCurrentElementIndex:(BOOL)autoScroll animated:(BOOL)animated;

@end

@implementation STXPagedView

- (void)setDataSource:(id<STXPagedViewDataSource>)dataSource {
    if ( ![_dataSource isEqual:dataSource] ) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (NSInteger)numberOfElements {
    return [_dataSource numberOfElementsInPagedView:self];
}

- (void)reloadData {
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    _currentElementIndex = -1;
    if ( 0 < self.numberOfElements ) {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.numberOfElements, _scrollView.frame.size.height);
        
        self.currentElementIndex = 0;
        [self __buildPageForCurrentElementIndex];
    }
}

- (NSInteger)indexOfPage:(STXPagedViewPage *)cell {
    return ceil(cell.frame.origin.x/_scrollView.frame.size.width);
}

- (STXPagedViewPage *)pageAtIndex:(NSInteger)index {
    __block STXPagedViewPage *page = nil;
    
    NSInteger cellOffset = _scrollView.frame.size.width * index;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(STXPagedViewPage *obj, NSUInteger idx, BOOL *stop) {
        if ( obj.frame.origin.x == cellOffset ) {
            page = obj;
            *stop = YES;
        }
    }];
    
    return page;
}

- (void)scrollToElementAtIndex:(NSInteger)index animated:(BOOL)animated {
    self.currentElementIndex = index;
    [self __buildPageForCurrentElementIndex:YES animated:animated];
}

- (STXPagedViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    if ( nil != __registeredNibs[identifier] ) {
        return [[(UINib *)__registeredNibs[identifier] instantiateWithOwner:nil options:nil] firstObject];
    }
    
    if ( nil != __registeredClasses[identifier] ) {
        return [[__registeredClasses[identifier] alloc] initWithReuseIdentifier:identifier];
    }
    
    return [[STXPagedViewPage alloc] initWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier {
    __registeredNibs[identifier] = nib;
}

- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier {
    __registeredClasses[identifier] = cellClass;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = ceil(_scrollView.contentOffset.x/_scrollView.frame.size.width);
    
    if ( currentIndex == self.numberOfElements ) {
        currentIndex = self.numberOfElements - 1;
    }
    
    self.currentElementIndex = currentIndex;
    [self __buildPageForCurrentElementIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentElementIndex = ceil(_scrollView.contentOffset.x/_scrollView.frame.size.width);
    
    NSMutableArray *pagesToRelease = [NSMutableArray array];
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(STXPagedViewPage *obj, NSUInteger idx, BOOL *stop) {
        NSInteger objIndex = [self indexOfPage:obj];
        
        if ( ( objIndex < self.currentElementIndex - 1 || objIndex > self.currentElementIndex + 1 ) && objIndex < self.numberOfElements &&  0 <= objIndex ) {
            [pagesToRelease addObject:obj];
        }
    }];
    
    [pagesToRelease enumerateObjectsUsingBlock:^(STXPagedViewPage *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    if ( [_delegate respondsToSelector:@selector(pagedViewDidEndDecelerating:)] ) {
        [_delegate pagedViewDidEndDecelerating:self];
    }
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [keyPath isEqualToString:@"currentElementIndex"] && [object isEqual:self] ) {
        if ( [_delegate respondsToSelector:@selector(pagedView:didEndDisplayingPage:forElementAtIndex:)] ) {
            NSInteger previousElementIndex = [change[NSKeyValueChangeOldKey] integerValue];
            if ( -1 != previousElementIndex ) {
                [_delegate pagedView:self didEndDisplayingPage:[self pageAtIndex:previousElementIndex] forElementAtIndex:previousElementIndex];
            }
        }
        
        if ( [_delegate respondsToSelector:@selector(pagedView:willDisplayPage:forElementAtIndex:)] ) {
            [_delegate pagedView:self willDisplayPage:[self pageAtIndex:self.currentElementIndex] forElementAtIndex:self.currentElementIndex];
        }
    }
}

#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self __initialSetup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self __initialSetup];
    }
    
    return self;
}

#pragma Private Methods

- (void)__initialSetup {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:_scrollView];
    
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:NSLayoutFormatAlignAllTop & NSLayoutAttributeBottom metrics:nil views:@{ @"scroll" : _scrollView }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scroll]|" options:NSLayoutFormatAlignAllLeading & NSLayoutFormatAlignAllTrailing metrics:nil views:@{ @"scroll" : _scrollView }]];
    
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _currentElementIndex = -1;
    __registeredNibs = [NSMutableDictionary dictionary];
    __registeredClasses = [NSMutableDictionary dictionary];
    
    [self addObserver:self forKeyPath:@"currentElementIndex" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)__buildPageForCurrentElementIndex {
    for ( NSInteger idx = self.currentElementIndex - 1; idx <= self.currentElementIndex + 1; idx++ ) {
        if ( -1 < idx && idx < self.numberOfElements && nil == [self pageAtIndex:idx] ) {
            STXPagedViewPage *page = [_dataSource pagedView:self pageForElementAtIndex:idx];
            page.frame = CGRectMake(_scrollView.frame.size.width * idx, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
            [_scrollView addSubview:page];
        }
    }
}

- (void)__buildPageForCurrentElementIndex:(BOOL)autoScroll animated:(BOOL)animated {
    [self __buildPageForCurrentElementIndex];
    
    if ( autoScroll ) {
        [_scrollView scrollRectToVisible:[self pageAtIndex:self.currentElementIndex].frame animated:animated];
    }
}

@end
