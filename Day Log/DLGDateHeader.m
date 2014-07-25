//
//  DLGDateHeader.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGDateHeader.h"

@interface DLGDateHeader ()

@property (nonatomic) UILabel *titleLabel;

@end

@implementation DLGDateHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.layer setCornerRadius:10];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(NSString *)title
{
    return self.titleLabel.text;
}

@end
