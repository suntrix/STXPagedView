//
//  PagesFromNibViewController.m
//  STXPagedScrollView
//
//  Created by Sebastian Owodziń on 09/07/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedScrollView project.
//  Project home page: https://github.com/suntrix/STXPagedScrollView
//

#import "PagesFromNibViewController.h"

#import "SimplePagedScrollViewPage.h"

@interface PagesFromNibViewController () {
    NSArray *   __data;
}

@end

@implementation PagesFromNibViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __data = @[ [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor] ];
    
    [self.pagedView registerNib:[UINib nibWithNibName:@"SimplePagedScrollViewPage" bundle:[NSBundle mainBundle]] forPageReuseIdentifier:@"Simple"];
    
    self.pagedView.delegate = self;
    self.pagedView.dataSource = self;

    [self.pagedView addObserver:self forKeyPath:@"currentElementIndex" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pagedView removeObserver:self forKeyPath:@"currentElementIndex"];
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [keyPath isEqualToString:@"currentElementIndex"] && [object isEqual:self.pagedView] ) {
        self.pageInfoLabel.title = [NSString stringWithFormat:@"%lu / %lu", self.pagedView.currentElementIndex+1, self.pagedView.numberOfElements];
    }
}

#pragma mark STXPagedScrollViewDataSource

- (NSInteger)numberOfElementsInPagedScrollView:(STXPagedScrollView *)pagedScrollView {
    return __data.count;
}

- (STXPagedScrollViewPage *)pagedScrollView:(STXPagedScrollView *)pagedScrollView pageForElementAtIndex:(NSInteger)index {
    SimplePagedScrollViewPage *page = (SimplePagedScrollViewPage *)[pagedScrollView dequeueReusablePageWithIdentifier:@"Simple"];
    
    page.titleLabel.text = NSStringFromClass([__data[index] class]);
    page.colorView.backgroundColor = __data[index];
    
    return page;
}

@end
