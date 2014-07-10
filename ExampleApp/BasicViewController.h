//
//  BasicViewController.h
//  ExampleApp
//
//  Created by Sebastian Owodziń on 06/05/14.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedScrollView project.
//  Project home page: https://github.com/suntrix/STXPagedScrollView
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController <STXPagedScrollViewDataSource, STXPagedScrollViewDelegate>

@property (weak, nonatomic) IBOutlet STXPagedScrollView *pagedView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageInfoLabel;

@end
