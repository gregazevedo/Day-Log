//
//  DLGTableViewCell.m
//  Day Log
//
//  Created by Greg Azevedo on 7/21/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGTableViewCell.h"
#import "LogItem+Helpers.h"
#import "Note.h"

@interface DLGTableViewCell ()


@end

@implementation DLGTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)configureForLogItem:(LogItem *)item
{
    self.dateLabel.text = item.timeString;
    self.durationLabel.text = item.durationString;
    self.timeLabel.text = item.timeString;
    self.notesLabel.text = item.note.contents;
}



@end
