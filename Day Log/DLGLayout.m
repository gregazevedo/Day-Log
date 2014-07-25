//
//  DLGLayout.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGLayout.h"

@interface DLGLayout()
{
    UIEdgeInsets insets;
//    CGFloat displacementForEditing;
    CGFloat interItemSpacing;
}
@property (nonatomic) id<DLGLayoutModel> dataSource;
//@property (nonatomic) NSMutableDictionary *scrollLayoutInfo;
//@property (nonatomic) NSMutableDictionary *cellLayoutInfo;
//@property (nonatomic) NSMutableDictionary *headerLayoutInfo;

//@property (nonatomic) NSIndexPath *indexToScrollTo;

@property (nonatomic) NSMutableDictionary *currentCellAttributes;
@property (nonatomic) NSMutableDictionary *cachedCellAttributes;

@property (nonatomic) NSMutableDictionary *currentHeaderAttributes;
@property (nonatomic) NSMutableDictionary *cachedHeaderAttributes;

@property (nonatomic, strong) NSMutableArray *indexPathsToBatchRemove;
@property (nonatomic, strong) NSMutableArray *indexPathsToBatchInsert;


@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedSectionIndices;

@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedSectionIndices;

@property (nonatomic, strong) NSMutableArray *movedIndexPaths;
@property (nonatomic, strong) NSMutableArray *movedSectionIndices;

@end


@implementation DLGLayout

#pragma mark - SETUP

-(DLGLayout *)initWithDataSource:(id<DLGLayoutModel>)dataSource
{
    if (self = [super init]) {
        self.dataSource = dataSource;
        CGFloat top = 0;
        CGFloat left = 0;
        CGFloat bottom = 0;
        CGFloat right = 0;
        insets = UIEdgeInsetsMake(top,left,bottom,right);
        interItemSpacing = 15;
    }
    return self;
}

-(void)resetAttributes
{
    self.currentHeaderAttributes = [NSMutableDictionary dictionary];
    self.currentCellAttributes = [NSMutableDictionary dictionary];
    
    for(NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSIndexPath *sectionIndex = [NSIndexPath indexPathForItem:0 inSection:section];
        [self.currentHeaderAttributes setObject:[self setHeaderForIndexPath:sectionIndex] forKey:sectionIndex];
        
        for(NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self.currentCellAttributes setObject:[self setCellForIndexPath:indexPath] forKey:indexPath];
        }
    }
}

-(UICollectionViewLayoutAttributes *)setCellForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat centerY = ([self.dataSource sizeForIndexPath:indexPath].height + interItemSpacing)/2;
    CGFloat height = [self.dataSource sizeForIndexPath:indexPath].height + interItemSpacing;
    CGFloat multiplier = (indexPath.row+1)*(indexPath.section+1);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = [self.dataSource sizeForIndexPath:indexPath];
    attributes.center = CGPointMake(self.collectionView.bounds.size.width/2, centerY+height*multiplier);
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));

    return [self.currentCellAttributes objectForKey:indexPath];
}


-(UICollectionViewLayoutAttributes *)setHeaderForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat centerY = ([self.dataSource headerSize].height + interItemSpacing)/2;
    CGFloat height = [self.dataSource headerSize].height + interItemSpacing;
    CGFloat multiplier = indexPath.row*(indexPath.section+1);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Header" withIndexPath:indexPath];
    attributes.size = [self.dataSource headerSize];
    attributes.center = CGPointMake(self.collectionView.bounds.size.width/2, centerY+height*multiplier);
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));

    return [self.currentHeaderAttributes objectForKey:indexPath];
}

#pragma mark - PREPARATION

-(void)prepareLayout
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    [super prepareLayout];
    
    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes copyItems:YES];
    self.cachedHeaderAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentHeaderAttributes copyItems:YES];
    [self resetAttributes];

    if (!self.currentCellAttributes) {
    }
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' %@",[self class],NSStringFromSelector(_cmd),updateItems);
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.insertedIndexPaths     = [NSMutableArray array];
    self.insertedSectionIndices = [NSMutableArray array];
    self.removedIndexPaths      = [NSMutableArray array];
    self.removedSectionIndices  = [NSMutableArray array];
    self.movedIndexPaths        = [NSMutableArray array];
    self.movedSectionIndices    = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                
                if (updateItem.indexPathAfterUpdate.item == NSNotFound) {
                    [self.insertedSectionIndices addObject:@(updateItem.indexPathAfterUpdate.section)];
                } else {
                    [self.insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
                }
                break;
            case UICollectionUpdateActionDelete:
                
                if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                    [self.removedSectionIndices addObject:@(updateItem.indexPathBeforeUpdate.section)];
                } else {
                    [self.removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
                }
                break;
            case UICollectionUpdateActionMove:
                if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                    [self.movedSectionIndices addObject:@(updateItem.indexPathBeforeUpdate.section)];
                } else {
                    [self.movedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
                }
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
}

-(CGSize)collectionViewContentSize
{
    CGFloat spacedHeight = self.dataSource.averageItemSize.height + interItemSpacing + insets.top + insets.bottom;
    CGFloat width = self.dataSource.averageItemSize.width + insets.left + insets.right;
    CGFloat headerHeight = self.dataSource.headerSize.height;
    
    NSInteger numItems = 0;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        numItems += [self.collectionView numberOfItemsInSection:section];
    }
    CGFloat navBarHeight = 70;
    CGFloat height = numItems * spacedHeight + numSections * headerHeight + navBarHeight;
    NSLog(@"total content size: %f %f", width, height);
    return CGSizeMake(width, height);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    for (NSIndexPath *key in self.currentCellAttributes) {
        UICollectionViewLayoutAttributes *attributes = [self.currentCellAttributes objectForKey:key];
        if(CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }
    for (NSIndexPath *key in self.currentHeaderAttributes) {
        UICollectionViewLayoutAttributes *attributes = [self.currentHeaderAttributes objectForKey:key];
        if(CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }
    NSLog(@"attributes for: %@\n %@",[self printRect:rect], allAttributes);
    return allAttributes;
}


-(void)queueItemRemovalForIndexPath:(NSIndexPath *)indexPath
{
    if (!self.indexPathsToBatchRemove) {
        self.indexPathsToBatchRemove = [NSMutableArray array];
    }
    [self.indexPathsToBatchRemove addObject:indexPath];
    
//    for (NSIndexPath *key in self.cachedCellAttributes) {
//        if (key.row >= indexPath.row && key.section == indexPath.section) {
//            NSIndexPath *followingIndex = [NSIndexPath indexPathForItem:key.row+1 inSection:key.section];
//            if ([self.collectionView cellForItemAtIndexPath:followingIndex]) {
//                //shift attribute up by 1
//                UICollectionViewLayoutAttributes *followingAttr = [self.currentCellAttributes objectForKey:followingIndex];
//                [self.currentCellAttributes setObject:followingAttr forKey:key];
//            } else {
//                //remove the last key
//                [self.currentCellAttributes removeObjectForKey:followingIndex];
//            }
//        }
//    }
}

-(void)queueItemInsertionForIndexPath:(NSIndexPath *)indexPath
{
    if (!self.indexPathsToBatchInsert) {
        self.indexPathsToBatchInsert = [NSMutableArray array];
    }
    [self.indexPathsToBatchInsert addObject:indexPath];
    //update main attributes dict
//    [self.currentCellAttributes setObject:[self setCellForIndexPath:indexPath] forKey:indexPath];
}

-(void)updateAndScrollToIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [[self layoutAttributesForItemAtIndexPath:indexPath] copy];

    if (self.indexPathsToBatchInsert || self.indexPathsToBatchRemove) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:self.indexPathsToBatchInsert];
            [self.collectionView deleteItemsAtIndexPaths:self.indexPathsToBatchRemove];
            [self.collectionView setContentOffset:CGPointMake(0, attributes.frame.origin.y-100) animated:YES];

        }completion:^(BOOL finished) {
            self.indexPathsToBatchRemove = nil;
            self.indexPathsToBatchInsert = nil;
        }];
    } else {
        [self.collectionView setContentOffset:CGPointMake(0, attributes.frame.origin.y-100) animated:YES];
    }
}

-(void)updateForSelectionAtIndexPath:(NSIndexPath *)indexPath WithScreenHeight:(CGFloat)height
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    [self updateAndScrollToIndexPath:indexPath];
}

-(void)updateForDeselectionAtIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    [self updateAndScrollToIndexPath:indexPath];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

//for inserts and initial selection
//all items pass into here, need to filter
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
        NSLog(@"inserting row: %i sec: %i", itemIndexPath.row, itemIndexPath.section);
        //newly inserted note
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.alpha = 0.5;
        attributes.size = [self.dataSource sizeForSelectedIndexPath];

         //maybe set frame to be on screen frame and set the whole content size to just be the screen when editing
        //make it differetn, expand frame
    }
    return attributes;
    
    
}


//for deletions and final selections
-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.removedIndexPaths containsObject:itemIndexPath]) {
        NSLog(@"removing row: %i sec: %i", itemIndexPath.row, itemIndexPath.section);
        //newly inserted note
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.center = CGPointMake(-attributes.center.x, attributes.center.y-attributes.size.height);
        //maybe set frame to be on screen frame and set the whole content size to just be the screen when editing
        //make it differetn, expand frame
        
    }
    return attributes;
}




// called inside an animation block after the update
- (void)finalizeCollectionViewUpdates
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    [super finalizeCollectionViewUpdates];
    
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.indexToScrollTo];
//    [self.collectionView setContentOffset:CGPointMake(0, attributes.frame.origin.y-100) animated:YES];

    
    self.insertedIndexPaths     = nil;
    self.insertedSectionIndices = nil;
    self.removedIndexPaths      = nil;
    self.removedSectionIndices  = nil;
    self.movedIndexPaths        = nil;
    self.movedSectionIndices    = nil;
}


-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    NSLog(@"proposed offset: %@", [self printCenter:proposedContentOffset]);
    
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    NSLog(@"proposed offset: %@ velocity: %@", [self printCenter:proposedContentOffset], [self printCenter:velocity]);
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
//    return NO;
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}









//debug

-(NSString *)printRect:(CGRect)rect
{
    return [NSString stringWithFormat:@"rect: %f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

-(NSString *)printCenter:(CGPoint)center
{
    return [NSString stringWithFormat:@"center: %f, %f", center.x, center.y];
}

-(NSString *)printIndex:(NSIndexPath *)index
{
    if (index.section == NSNotFound) {
        
    }
    return [NSString stringWithFormat:@"index row: %i section: %i",index.row, index.section];
    
    
}









////insertions can only happen in today section
////editing an item from another day puts it into todays section, ordered by last edit not creation
//-(void)updateLayoutInformationForInsertedItems
//{
//    NSInteger todaysNoteCountInCV = [self.collectionView numberOfItemsInSection:[self.dataSource todaysSection]];
//    NSInteger todaysNoteCountInDS = [self.dataSource numberOfItemsInSection:[self.dataSource todaysSection]];
//    for(NSInteger item = todaysNoteCountInCV; item < todaysNoteCountInDS; item++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:[self.dataSource todaysSection]];
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [self.cellLayoutInfo setObject:attributes forKey:indexPath];
//    }
//}
//
////removals can happen in any section
//-(void)updateLayoutInformationForRemovedItems
//{
//    NSInteger numSectionsInCollectionView = [self.collectionView numberOfSections];
//    NSInteger numSectionsInDataSource = [self.dataSource numberOfSections];
//    
//    for(NSInteger section = numSectionsInCollectionView; section < numSectionsInDataSource; section++) {
//        NSIndexPath *sectionIndex = [NSIndexPath indexPathForItem:0 inSection:section];
//        
//        NSInteger numItemsInCVSection = [self.collectionView numberOfItemsInSection:section];
//        NSInteger numItemsInDSSection = [self.dataSource numberOfItemsInSection:section];
//        
//        for(NSInteger item = 0; item < numItemsInSection; item++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
//            [self.cellLayoutInfo setObject:attributes forKey:indexPath];
//        }
//    }
//}


@end
