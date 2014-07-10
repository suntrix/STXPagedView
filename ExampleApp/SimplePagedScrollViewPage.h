//
//  SimplePagedScrollViewPage.h
//  STXPagedScrollView
//
//  Created by Sebastian Owodziń on 09/07/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedScrollView project.
//  Project home page: https://github.com/suntrix/STXPagedScrollView
//

#import <STXPagedScrollView/STXPagedScrollView.h>

@interface SimplePagedScrollViewPage : STXPagedScrollViewPage

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIView *colorView;

@end
