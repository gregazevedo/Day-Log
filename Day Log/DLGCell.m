//
//  DLGCell.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGCell.h"

@interface DLGCell ()


@end


@implementation DLGCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.contentsTextView = [[UITextView alloc] initWithFrame:self.bounds];
        [self.contentsTextView setUserInteractionEnabled:NO];
        [self.contentView addSubview:self.contentsTextView];
        
    }
    return self;
}

-(void)setContents:(NSString *)contents
{
    self.contentsTextView.text = contents;
}

-(NSString *)contents
{
    return self.contentsTextView.text;
}



@end
