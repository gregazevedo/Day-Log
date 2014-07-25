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
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1]];
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

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //taking over selection responsibility
    [self selectItemAtIndexPath:indexPath];
    return NO;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //taking over selection responsibility
    [self deselectItemAtIndexPath:indexPath andDone:YES];
    return NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self selectedIndexPath]) {
        [self deselectItemAtIndexPath:[self selectedIndexPath] andDone:YES];
    }
}

#pragma mark - INTERFACE METHODS

-(void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"to select index: %@\n selected index: %@", indexPath, [self selectedIndexPath]);
    if ([indexPath isEqual:[self selectedIndexPath]]) {
        return; //already selected
    }
    DLGCell *newCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!newCell) {
        return; //cell doesnt exist or nil index
    }
    if ([self selectedIndexPath]) {
        [self deselectItemAtIndexPath:[self selectedIndexPath] andDone:NO];
    }
    [newCell.contentsTextView becomeFirstResponder];
    [newCell.contentsTextView setDelegate:self];
    latestCursorPosition = [newCell.contentsTextView caretRectForPosition:newCell.contentsTextView.endOfDocument].origin.y;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:0];
    [self.layout updateForSelectionAtIndexPath:indexPath WithScreenHeight:self.view.frame.size.height];
}

-(void)deselectItemAtIndexPath:(NSIndexPath *)indexPath andDone:(BOOL)doneEditing
{
    NSLog(@"to deselect index: %@\n selected index: %@", indexPath, [self selectedIndexPath]);

    DLGCell *oldCell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!oldCell) {
        return;
    }
    if ([oldCell.contents isEqualToString:@""] && ![indexPath isEqual:[self.viewModel lastIndex]]) {
        [self removeItemAtIndexPath:indexPath];
    } else {
        [self.viewModel updateContentsForIndexPath:indexPath withContents:oldCell.contents];
    }
    [oldCell.contentsTextView resignFirstResponder];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    latestCursorPosition = 0;
    if (doneEditing) {
        [self.viewModel saveChanges];
        [self.layout updateForDeselectionAtIndexPath:indexPath];
    }
}

-(void)insertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel insertNewEntryAtIndexPath:indexPath];
    [self.layout queueItemInsertionForIndexPath:indexPath];
//    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel removeEntryAtIndexPath:indexPath];
    [self.layout queueItemRemovalForIndexPath:indexPath];
//    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

-(NSIndexPath *)selectedIndexPath
{
    return [[self.collectionView indexPathsForSelectedItems] firstObject];
}

-(NSIndexPath *)nextIndexPath
{
    DLGCell *cell = (DLGCell *)[self.collectionView cellForItemAtIndexPath:[self selectedIndexPath]];
    if (!cell || [cell.contents isEqualToString:@""]) {
        return nil;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:[self selectedIndexPath].row+1 inSection:[self selectedIndexPath].section];
    if (![self.collectionView cellForItemAtIndexPath:nextIndexPath]) {
        [self insertItemAtIndexPath:nextIndexPath];
    }
    return nextIndexPath;
}

-(NSIndexPath *)previousIndexPath
{
    if (![self selectedIndexPath]) {
        NSLog(@"Bad Access - no selected index path");
        return nil;
    }
    if ([self selectedIndexPath].row == 0) {
        NSLog(@"No previous to first cell of section");
        if ([[self selectedIndexPath] isEqual:[self.viewModel lastIndex]]) {
            return [self selectedIndexPath];
        }
        //return next instead
        return [NSIndexPath indexPathForItem:[self selectedIndexPath].row+1 inSection:[self selectedIndexPath].section];
    }
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:[self selectedIndexPath].row-1 inSection:[self selectedIndexPath].section];
    return previousIndexPath;
}

#pragma mark - TEXT VIEW DELEGATE

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL newLineInput = [text isEqualToString:@"\n"];
    BOOL isCurrentlyEmpty = [textView.text isEqualToString:@""];
    BOOL backspaceInput = strcmp([text cStringUsingEncoding:NSUTF8StringEncoding], "\b") == -8 ? YES : NO;
    if (newLineInput && isCurrentlyEmpty) {
        [self deselectItemAtIndexPath:[self selectedIndexPath] andDone:YES];
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
