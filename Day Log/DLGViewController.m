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
{
    CGFloat latestCursorPosition;
}
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) DLGLayout *layout;

@end


@implementation DLGViewController

#pragma mark - SETUP

-(void)loadView
{
    [super loadView];
    [self.navigationItem setTitle:@"Day Log"];
    [self.viewModel fetchNotesForToday];
    [self loadCollectionView];
}

-(void)loadCollectionView
{
    [self setLayout:[[DLGLayout alloc] initWithDataSource:self.viewModel]];
    [self setCollectionView:[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout]];
    [self.collectionView registerClass:[DLGCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[DLGDateHeader class] forSupplementaryViewOfKind:@"Header" withReuseIdentifier:@"Header"];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setAllowsMultipleSelection:NO];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.collectionView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selectItemAtIndexPath:[self.viewModel lastIndex]];
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

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DLGDateHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    header.title = [self.viewModel titleForHeaderAtIndexPath:indexPath];
    return header;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel numberOfSections];
}

#pragma mark - COLLECTION VIEW DELEGATE METHODS

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectItemAtIndexPath:indexPath];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.selectedIndexPath) {
        [self deselectItemAtIndexPath:self.selectedIndexPath];
    }
}

#pragma mark - INTERFACE METHODS

-(void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLGCell *newCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!newCell || [indexPath isEqual:self.selectedIndexPath]) {
        return;
    }
    [self deselectItemAtIndexPath:self.selectedIndexPath];
    [newCell.contentsTextView becomeFirstResponder];
    [newCell.contentsTextView setDelegate:self];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    latestCursorPosition = [newCell.contentsTextView caretRectForPosition:newCell.contentsTextView.endOfDocument].origin.y;
    [self.layout transitionToEditCellLayout];
}

-(void)deselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLGCell *oldCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (oldCell) {
        [self.viewModel updateContentsForIndexPath:indexPath withContents:oldCell.contents];
        [self.viewModel saveChanges];
        [oldCell.contentsTextView resignFirstResponder];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        latestCursorPosition = 0;
        [self.layout transitionToBrowsingLayout];
    }
}

-(NSIndexPath *)selectedIndexPath
{
    return [[self.collectionView indexPathsForSelectedItems] firstObject];
}

-(NSIndexPath *)nextIndexPath
{
    if (!self.selectedIndexPath) {
        NSLog(@"Bad Access - no selected index path");
        return nil;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:self.selectedIndexPath.row+1 inSection:self.selectedIndexPath.section];
    if (![self.collectionView cellForItemAtIndexPath:nextIndexPath]) {
        [self.viewModel insertNewEntryAtIndexPath:nextIndexPath];
        [self.collectionView insertItemsAtIndexPaths:@[nextIndexPath]];
    }
    return nextIndexPath;
}

-(NSIndexPath *)previousIndexPath
{
    if (!self.selectedIndexPath) {
        NSLog(@"Bad Access - no selected index path");
        return nil;
    }
    if (self.selectedIndexPath.row == 0) {
        NSLog(@"No previous to first cell of section");
        return self.selectedIndexPath;
    }
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:self.selectedIndexPath.row-1 inSection:self.selectedIndexPath.section];
    DLGCell *curCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:previousIndexPath];
    if ([curCell.contents isEqualToString:@""]) {
        [self.viewModel removeEntryAtIndexPath:self.selectedIndexPath];
        [self.collectionView deleteItemsAtIndexPaths:@[self.selectedIndexPath]];
    }
    return previousIndexPath;
}

#pragma mark - TEXT VIEW DELEGATE

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL newLineInput = [text isEqualToString:@"\n"];
    BOOL isCurrentlyEmpty = [textView.text isEqualToString:@""];
    BOOL backspaceInput = strcmp([text cStringUsingEncoding:NSUTF8StringEncoding], "\b") == -8 ? YES : NO;
    if (newLineInput && isCurrentlyEmpty) {
        [self deselectItemAtIndexPath:self.selectedIndexPath];
        return NO;
    }
    if (newLineInput && !isCurrentlyEmpty) {
        [self selectItemAtIndexPath:[self nextIndexPath]];
        return NO;
    }
    if (backspaceInput && isCurrentlyEmpty) {
        [self selectItemAtIndexPath:[self previousIndexPath]];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextPosition* pos = textView.endOfDocument;
    CGRect currentRect = [textView caretRectForPosition:pos];
    if (currentRect.origin.y > latestCursorPosition) {
        NSLog(@"new line! latest: %f", latestCursorPosition);
        latestCursorPosition = currentRect.origin.y;
    }
}

@end
