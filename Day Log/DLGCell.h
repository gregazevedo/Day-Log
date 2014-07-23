//
//  DLGCell.h
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class LogEntry;

@interface DLGCell : UICollectionViewCell

@property (nonatomic) UITextView *contentsTextView;
@property (nonatomic) NSString *contents;

@end
