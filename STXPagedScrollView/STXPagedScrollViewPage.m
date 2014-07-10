//
//  STXPagedScrollViewPage.m
//  STXPagedScrollView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//

#import "STXPagedScrollViewPage.h"

#import "STXPagedScrollView.h"

@implementation STXPagedScrollViewPage

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if ( self ) {
        _reuseIdentifier = reuseIdentifier;
    }
    
    return self;
}

@end
