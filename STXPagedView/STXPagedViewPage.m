//
//  STXPagedViewPage.m
//  STXPagedView
//
//  Created by Sebastian Owodziń on 16/01/2014.
//  Copyright (c) 2014 Sebastian Owodziń. All rights reserved.
//
//  This is a part of STXPagedView project.
//  Project home page: https://github.com/suntrix/STXPagedView
//

#import "STXPagedViewPage.h"

#import "STXPagedView.h"

@implementation STXPagedViewPage

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if ( self ) {
        _reuseIdentifier = reuseIdentifier;
    }
    
    return self;
}

@end
