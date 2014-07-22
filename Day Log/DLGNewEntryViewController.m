//
//  DLGNewEntryViewController.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGNewEntryViewController.h"
#import "DLGDataSource.h"

@interface DLGNewEntryViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *noteField;
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;

- (IBAction)save:(id)sender;

@end

@implementation DLGNewEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender
{
    NSDate *start = [self.startDatePicker date];
    NSDate *end = [self.endDatePicker date];
    NSString *note = [self.noteField text];
    [[DLGDataSource data] insertNewEntryWithDictionary:@{@"startDate": start, @"endDate":end, @"note":note}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
