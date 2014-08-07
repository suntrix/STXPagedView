//
//  STXPagedViewPage.h
//  STXPagedView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedView project.
//  Project home page: https://github.com/suntrix/STXPagedView
//

#import <UIKit/UIKit.h>

@interface STXPagedViewPage : UIView <NSCoding>

@property (copy, nonatomic, readonly) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
