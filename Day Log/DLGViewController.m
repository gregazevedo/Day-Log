//
//  DLGViewController.m
//  Day Log
//
//  Created by Greg Azevedo on 7/21/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGViewController.h"
#import "DLGCell.h"
#import "DLGDateHeader.h"
#import "DLGLayout.h"

@interface DLGViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end


@implementation DLGViewController

#pragma mark - SETUP

-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"Day Log";
    [self.viewModel loadLogEntries];
    [self loadCollectionView];
}

-(void)loadCollectionView
{
    DLGLayout *layout = [DLGLayout new];
    layout.layoutDataSource = self.viewModel;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView registerClass:[DLGCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[DLGDateHeader class] forSupplementaryViewOfKind:@"Header" withReuseIdentifier:@"Header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView setAllowsMultipleSelection:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - VIEW INTERFACE PROTOCOL METHODS

-(void)insertNewEntryWithContents:(NSString *)contents atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView insertItemsAtIndexPaths:@[[self.viewModel lastIndex]]];
    [self.collectionView scrollToItemAtIndexPath:[self.viewModel lastIndex] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

#pragma mark - COLLECTION VIEW DATA SOURCE METHODS

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLGCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contents = [self.viewModel contentsForIndexPath:indexPath];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

#pragma mark - COLLECTION VIEW DELEGATE METHODS

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveSelectionFromIndexPath:nil toIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveSelectionFromIndexPath:indexPath toIndexPath:nil];
 }

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UICollectionView *cv = (UICollectionView *)scrollView;
    NSIndexPath *indexPath = [[cv indexPathsForSelectedItems] firstObject];
    DLGCell *cell = (DLGCell *)[cv cellForItemAtIndexPath:indexPath];
    if (cell) {
        [self.viewModel updateContentsForIndexPath:indexPath withContents:cell.contents];
        [cell.contentsTextView resignFirstResponder];
        [self.viewModel saveChanges];
    }
}

-(void)removeEmptyEntry
{
    NSLog(@"removing from selected: %@",[self.collectionView indexPathsForSelectedItems]);
    NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] firstObject];
    if (index.row > 1) {
        NSIndexPath *prevIndex = [NSIndexPath indexPathForItem:index.row-1 inSection:index.section];
        [self.viewModel removeEntryAtIndexPath:index];
        [self.collectionView deleteItemsAtIndexPaths:@[index]];
        [self moveSelectionFromIndexPath:index toIndexPath:prevIndex];
    }
}

-(void)insertNewEntry
{
    NSLog(@"inserting from selected: %@",[self.collectionView indexPathsForSelectedItems]);
    NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] firstObject];
    NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:index.row+1 inSection:index.section];
    [self.viewModel insertNewEntryAtIndexPath:nextIndex];
    [self.collectionView insertItemsAtIndexPaths:@[nextIndex]];
    [self moveSelectionFromIndexPath:index toIndexPath:nextIndex];
}

-(void)moveSelectionFromIndexPath:(NSIndexPath *)toDeselect toIndexPath:(NSIndexPath *)toSelect
{
    if (toDeselect) {
        DLGCell *oldCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:toDeselect];
        [self.viewModel updateContentsForIndexPath:toDeselect withContents:oldCell.contents];
        [oldCell resignFirstResponder];
        [self.collectionView deselectItemAtIndexPath:toDeselect animated:YES];
    }
    if (toSelect) {
        DLGCell *newCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:toSelect];
        [newCell.contentsTextView becomeFirstResponder];
        [newCell.contentsTextView setDelegate:self];
        [self.collectionView selectItemAtIndexPath:toSelect animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}

#pragma mark - TEXT VIEW DELEGATE

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL newLineInput = [text isEqualToString:@"\n"];
    BOOL isCurrentlyEmpty = [textView.text isEqualToString:@""];
    
    if (newLineInput && isCurrentlyEmpty) {
        NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] firstObject];
        [self moveSelectionFromIndexPath:index toIndexPath:nil];
        return NO;
    }
    if (newLineInput && !isCurrentlyEmpty) {
        [self insertNewEntry];
        return NO;
    }
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8 && isCurrentlyEmpty) {
        [self removeEmptyEntry];
        return NO;
    }
    return YES;
}

@end
