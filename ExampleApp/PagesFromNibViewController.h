//
//  PagesFromNibViewController.h
//  ExampleApp
//
//  Created by Sebastian Owodziń on 09/07/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedView project.
//  Project home page: https://github.com/suntrix/STXPagedView
//

#import <UIKit/UIKit.h>

@interface PagesFromNibViewController : UIViewController <STXPagedViewDataSource, STXPagedViewDelegate>

@property (weak, nonatomic) IBOutlet STXPagedView *pagedView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageInfoLabel;

@end
