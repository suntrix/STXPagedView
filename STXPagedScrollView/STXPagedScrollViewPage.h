//
//  STXPagedScrollViewPage.h
//  STXPagedScrollView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STXPagedScrollViewPage : UIView <NSCoding>

@property (copy, nonatomic, readonly) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
