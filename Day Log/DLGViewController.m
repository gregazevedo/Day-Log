//
//  DLGViewController.m
//  Day Log
//
//  Created by Greg Azevedo on 7/21/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGViewController.h"
#import "DLGTableViewCell.h"
#import "DLGDataSource.h"
#import "LogItem+Helpers.h"
#import "Note.h"

@interface DLGViewController () <UITableViewDelegate>

@end

@implementation DLGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = [DLGDataSource data];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogItem *item = [[[DLGDataSource data] logEntries] objectAtIndex:indexPath.row];
    CGFloat dateHeight = 120;
    CGFloat noteHeight = [item.note.contents boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesDeviceMetrics attributes:nil context:nil].size.height;
    return dateHeight+noteHeight;
}

@end
