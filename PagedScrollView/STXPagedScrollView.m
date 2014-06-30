//
//  STXPagedScrollView.m
//  PagedScrollView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//

#import "STXPagedScrollView.h"

@interface STXPagedScrollView ()

@property (nonatomic, strong) UIScrollView *    _scrollView;

@property (nonatomic) NSInteger _currentElementIndex;

@property (nonatomic, strong) NSMutableDictionary *    _registeredNibs;
@property (nonatomic, strong) NSMutableDictionary *    _registeredClasses;

- (void)__initialSetup;

- (STXPagedScrollViewPage *)__buildPageForIndex:(NSInteger)index;

- (void)__deviceOrientationDidChanged:(NSNotification *)notification;

@end

@implementation STXPagedScrollView

- (void)setDataSource:(id<STXPagedScrollViewDataSource>)dataSource {
    if ( ![_dataSource isEqual:dataSource] ) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (NSInteger)currentElementIndex {
    return self._currentElementIndex;
}

- (NSInteger)numberOfElements {
    return [_dataSource numberOfElementsInPagedScrollView:self];
}

- (void)reloadData {
    [__scrollView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    __currentElementIndex = -1;
    if ( 0 < self.numberOfElements ) {
        __scrollView.contentSize = CGSizeMake(__scrollView.frame.size.width * self.numberOfElements, __scrollView.frame.size.height);
        
        self._currentElementIndex = 0;
        [__scrollView addSubview:[self __buildPageForIndex:self._currentElementIndex]];
        [__scrollView addSubview:[self __buildPageForIndex:self._currentElementIndex + 1]];
    }
}

- (NSInteger)indexOfPage:(STXPagedScrollViewPage *)cell {
    return ceil(cell.frame.origin.x/__scrollView.frame.size.width);
}

- (STXPagedScrollViewPage *)pageAtIndex:(NSInteger)index {
    __block STXPagedScrollViewPage *page = nil;
    
    NSInteger cellOffset = __scrollView.frame.size.width * index;
    
    [__scrollView.subviews enumerateObjectsUsingBlock:^(STXPagedScrollViewPage *obj, NSUInteger idx, BOOL *stop) {
        if ( obj.frame.origin.x == cellOffset ) {
            page = obj;
            *stop = YES;
        }
    }];
    
    return page;
}

- (void)scrollToElementAtIndex:(NSInteger)index animated:(BOOL)animated {
    self._currentElementIndex = index;
    STXPagedScrollViewPage *page = [self pageAtIndex:index];
    
    if ( nil == page ) {
        page = [self __buildPageForIndex:index];
        [__scrollView addSubview:page];
    }
    
    [__scrollView scrollRectToVisible:page.frame animated:animated];
}

- (STXPagedScrollViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    STXPagedScrollViewPage *page = nil;
    
    if ( nil != __registeredNibs[identifier] ) {
        page = [[(UINib *)__registeredNibs[identifier] instantiateWithOwner:nil options:nil] firstObject];
    }
    
    if ( nil != __registeredClasses[identifier] ) {
        page = [(STXPagedScrollViewPage *)[__registeredClasses[identifier] alloc] initWithReuseIdentifier:identifier];
    }
    
    if ( nil == page ) {
        page = [[STXPagedScrollViewPage alloc] initWithReuseIdentifier:identifier];
    }
    
    return page;
}

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier {
    __registeredNibs[identifier] = nib;
}

- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier {
    __registeredClasses[identifier] = cellClass;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    NSInteger newIndex = -1;
    
    if ( 0 < translation.x ) { // dragging right
        newIndex = __currentElementIndex-1;
        if ( newIndex < 0 ) {
            newIndex = -1;
        }
    }
    else { // dragging left
        newIndex = __currentElementIndex+1;
        if ( newIndex >= self.numberOfElements ) {
            newIndex = -1;
        }
    }
    
    if ( -1 != newIndex ) {
        self._currentElementIndex = newIndex;
        STXPagedScrollViewPage *page = [self pageAtIndex:self._currentElementIndex];
        if ( nil == page ) {
            page = [self __buildPageForIndex:self._currentElementIndex];
            [__scrollView addSubview:page];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self._currentElementIndex = ceil(__scrollView.contentOffset.x/__scrollView.frame.size.width);
    
    NSMutableArray *pagesToRelease = [NSMutableArray array];
    
    [__scrollView.subviews enumerateObjectsUsingBlock:^(STXPagedScrollViewPage *obj, NSUInteger idx, BOOL *stop) {
        NSInteger objIndex = [self indexOfPage:obj];
        
        if ( ( objIndex < self._currentElementIndex - 1 || objIndex > self._currentElementIndex + 1 ) && objIndex < self.numberOfElements &&  0 <= objIndex ) {
            [pagesToRelease addObject:obj];
        }
    }];
    
    [pagesToRelease enumerateObjectsUsingBlock:^(STXPagedScrollViewPage *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    if ( nil != _delegate ) {
        [_delegate pagedScrollViewDidEndDecelerating:self];
    }
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [keyPath isEqualToString:@"_currentElementIndex"] && [object isEqual:self] ) {
        if ( nil != _delegate ) {
            NSInteger previousElementIndex = [change[NSKeyValueChangeOldKey] integerValue];
            if ( -1 != previousElementIndex ) {
                [_delegate pagedScrollView:self didEndDisplayingPage:[self pageAtIndex:previousElementIndex] forElementAtIndex:previousElementIndex];
            }
            
            [_delegate pagedScrollView:self willDisplayPage:[self pageAtIndex:__currentElementIndex] forElementAtIndex:__currentElementIndex];
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
    __scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:__scrollView];
    
    [__scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"scroll" : __scrollView }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scroll]|" options:0 metrics:nil views:@{ @"scroll" : __scrollView }]];
    
    __scrollView.scrollEnabled = YES;
    __scrollView.pagingEnabled = YES;
    __scrollView.directionalLockEnabled = YES;
    __scrollView.showsHorizontalScrollIndicator = NO;
    __scrollView.showsVerticalScrollIndicator = NO;
    __scrollView.delegate = self;
    
    __currentElementIndex = -1;
    __registeredNibs = [NSMutableDictionary dictionary];
    __registeredClasses = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self addObserver:self forKeyPath:@"_currentElementIndex" options:NSKeyValueObservingOptionOld context:NULL];
}

- (STXPagedScrollViewPage *)__buildPageForIndex:(NSInteger)index {
    STXPagedScrollViewPage *page = [_dataSource pagedScrollView:self pageForElementAtIndex:index];
    
    page.frame = CGRectMake(__scrollView.frame.size.width * index, 0, __scrollView.frame.size.width, __scrollView.frame.size.height);
    
    return page;
}

- (void)__deviceOrientationDidChanged:(NSNotification *)notification {
    NSInteger currentCellIndex = self._currentElementIndex;
    
    [self reloadData];
    [self scrollToElementAtIndex:currentCellIndex animated:NO];
}

@end
