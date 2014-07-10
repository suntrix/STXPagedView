//
//  BasicViewController.m
//  ExampleApp
//
//  Created by Sebastian Owodziń on 06/05/14.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedScrollView project.
//  Project home page: https://github.com/suntrix/STXPagedScrollView
//

#import "BasicViewController.h"

@interface BasicViewController () {
    NSArray *   __data;
}

@end

@implementation BasicViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __data = @[ [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor] ];
    
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
    STXPagedScrollViewPage *page = [pagedScrollView dequeueReusablePageWithIdentifier:@"SomePageIdentifier"];
    
    page.backgroundColor = __data[index];
    
    return page;
}

@end
