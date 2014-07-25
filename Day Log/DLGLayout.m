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


@property (nonatomic) NSMutableDictionary *currentCellAttributes;
@property (nonatomic) NSMutableDictionary *cachedCellAttributes;

@property (nonatomic) NSMutableDictionary *currentHeaderAttributes;
@property (nonatomic) NSMutableDictionary *cachedHeaderAttributes;



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
//    UICollectionViewLayoutAttributes *attributes = [self.currentCellAttributes objectForKey:indexPath];
//    if (!attributes) {
//        attributes = [self setCellForIndexPath:indexPath];
//    }
//    NSLog(@"attributes for:%@\n %@\n %@\n",[self printIndex:indexPath],[self printRect:attributes.frame], [self printCenter:attributes.center]);
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
    UICollectionViewLayoutAttributes *attributes = [self.currentHeaderAttributes objectForKey:indexPath];
    if (!attributes) {
        attributes = [self setHeaderForIndexPath:indexPath];
     }
    NSLog(@"header attributes:%@\n %@\n %@\n",[self printIndex:indexPath],[self printRect:attributes.frame], [self printCenter:attributes.center]);
    return attributes;
}

#pragma mark - PREPARATION

-(void)prepareLayout
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    [super prepareLayout];
    
    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes copyItems:YES];
    self.cachedHeaderAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentHeaderAttributes copyItems:YES];
    [self resetAttributes];
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
    CGFloat height = numItems * spacedHeight + numSections * headerHeight;
    NSLog(@"total content size: %f %f", width, height);
    return CGSizeMake(width, height);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    for (NSIndexPath *key in self.currentCellAttributes) {
        UICollectionViewLayoutAttributes *attributes = [self.currentCellAttributes objectForKey:key];
        if(CGRectIntersectsRect(rect, attributes.frame)) {
            //is in rect
            [allAttributes addObject:attributes];
        }
    }
    for (NSIndexPath *key in self.currentHeaderAttributes) {
        UICollectionViewLayoutAttributes *attributes = [self.currentHeaderAttributes objectForKey:key];
        if(CGRectIntersectsRect(rect, attributes.frame)) {
            //is in rect
            [allAttributes addObject:attributes];
        }
    }
    NSLog(@"attributes for: %@\n %@",[self printRect:rect], allAttributes);
    return allAttributes;
}


//inserts
//prepare layout
//prepare for updates
//inital attributes for appearing

//
//
//-(void)updateForInsertAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
//    //inserting shouldnt do much, however typically followed by selection
//}

-(void)updateForSelectionAtIndexPath:(NSIndexPath *)indexPath WithScreenHeight:(CGFloat)height
{    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat bottomPoint = attributes.frame.origin.y+attributes.frame.size.height;
    CGFloat spaceUnderBottomPointOfSelectedCell = self.collectionViewContentSize.height - bottomPoint;
    CGFloat keyboardTop = 350; //~find real
    CGFloat diff = keyboardTop - spaceUnderBottomPointOfSelectedCell;
    if (diff > 0) {
        [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, diff, 0)];
    }
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    [self invalidateLayout];
}

-(void)updateForDeselectionAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self.collectionView setContentInset:UIEdgeInsetsMake(50, 0, 80, 0)]; //50 for account for nav bar at top and 80 for some slack at bottom
    [self invalidateLayout];
}

//for inserts and initial selection
//all items pass into here, need to filter
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' row: %i section: %i",[self class],NSStringFromSelector(_cmd),itemIndexPath.row, itemIndexPath.section);
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
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
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' row: %i section: %i",[self class],NSStringFromSelector(_cmd),itemIndexPath.row, itemIndexPath.section);
    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];

    if ([self.removedIndexPaths containsObject:itemIndexPath]) {
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
