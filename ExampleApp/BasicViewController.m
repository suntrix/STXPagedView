//
//  BasicViewController.m
//  ExampleApp
//
//  Created by Sebastian Owodziń on 06/05/14.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pageInfoLabel.title = [NSString stringWithFormat:@"%d / %d", self.pagedView.currentElementIndex+1, self.pagedView.numberOfElements];
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

#pragma mark STXPagedScrollViewDelegate

- (void)pagedScrollView:(STXPagedScrollView *)pagedScrollView willDisplayPage:(STXPagedScrollViewPage *)page forElementAtIndex:(NSInteger)index {
    NSLog(@"%s %@ | %d", __PRETTY_FUNCTION__, page, index);
}

- (void)pagedScrollView:(STXPagedScrollView *)pagedScrollView didEndDisplayingPage:(STXPagedScrollViewPage *)page forElementAtIndex:(NSInteger)index {
    NSLog(@"%s %@ | %d", __PRETTY_FUNCTION__, page, index);
}

- (void)pagedScrollViewDidEndDecelerating:(STXPagedScrollView *)pagedScrollView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.pageInfoLabel.title = [NSString stringWithFormat:@"%d / %d", self.pagedView.currentElementIndex+1, self.pagedView.numberOfElements];
}

@end
