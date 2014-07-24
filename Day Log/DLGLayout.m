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
    CGFloat displacementForEditing;
    CGFloat interItemSpacing;
}
@property (nonatomic) id<DLGLayoutModel> dataSource;
@property (nonatomic) NSDictionary *scrollLayoutInformation;
@property (nonatomic) NSMutableArray *todaySectionAttributes;
@property (nonatomic) NSIndexPath *selectedIndex;

@end


@implementation DLGLayout

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
        displacementForEditing = 0;
    }
    return self;
}

-(NSIndexPath *)selectedIndex
{
    return [[self.collectionView indexPathsForSelectedItems] firstObject];
}

-(void)transitionToBrowsingLayout
{
    
}

-(void)transitionToEditCellLayout
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.selectedIndex];
    displacementForEditing = 50-attributes.frame.origin.y;
    [self.collectionView performBatchUpdates:^{
        NSLog(@"UPDATING");
    } completion:^(BOOL finished) {
        NSLog(@"DONE UPDATING");
    }];
    [self invalidateLayout];
}

-(void)prepareLayout
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    [super prepareLayout];
#warning bad - layout info will never be updated on inserts/deletes, either set to nil on updates or do better checking here
    if (self.scrollLayoutInformation) {
        NSLog(@"BAD");
        return;
    }
    self.scrollLayoutInformation = [self resetAttributes];
}

-(NSDictionary *)resetAttributes
{
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerInformation = [NSMutableDictionary dictionary];
    
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        NSIndexPath *sectionIndex = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:@"Header" atIndexPath:sectionIndex];
        [headerInformation setObject:headerAttributes forKey:sectionIndex];
        
        NSInteger numItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItemsInSection; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
        }
    }
    [layoutInformation setObject:cellInformation forKey:@"cellInfo"];
    [layoutInformation setObject:headerInformation forKey:@"headerInfo"];
    return layoutInformation;
}

-(CGSize)collectionViewContentSize
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    CGFloat spacedHeight = [self.dataSource averageItemSize].height + interItemSpacing;
    CGFloat width = [self.dataSource averageItemSize].width + insets.left + insets.right;
    CGFloat headerHeight = [self.dataSource headerSize].height;
    
    NSInteger numItems = 0;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        numItems += [self.collectionView numberOfItemsInSection:section];
    }
    CGFloat height = numItems * (spacedHeight + insets.top + insets.bottom) + numSections * headerHeight;
    return CGSizeMake(width, height);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    NSLog(@"%@",[self printRect:rect]);
    
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.scrollLayoutInformation.count];
    for(NSString *key in self.scrollLayoutInformation) {
        NSDictionary *attributesDict = [self.scrollLayoutInformation objectForKey:key];
        for(NSIndexPath *key in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = [attributesDict objectForKey:key];
            
            if (self.selectedIndex) {
                attributes = [attributes copy];
                attributes.frame = CGRectMake(attributes.frame.origin.x, attributes.frame.origin.y+displacementForEditing, attributes.frame.size.width, attributes.frame.size.height);
            }
            
            if(CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes];
            }
        }
    }
    return myAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' %@",[self class],NSStringFromSelector(_cmd),[self printIndex:indexPath]);
    
    UICollectionViewLayoutAttributes *attributes = [[self.scrollLayoutInformation objectForKey:@"cellInfo"] objectForKey:indexPath];
    if (!attributes) {
        CGFloat centerY = ([self.dataSource sizeForIndexPath:indexPath].height + interItemSpacing)/2;
        CGFloat height = [self.dataSource sizeForIndexPath:indexPath].height + interItemSpacing;
        CGFloat multiplier = (indexPath.row+1)*(indexPath.section+1);
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = [self.dataSource sizeForIndexPath:indexPath];
        attributes.center = CGPointMake(160, centerY+height*multiplier);
    }
    
//    if (self.selectedIndex) {
//        //put cell at top
//        UICollectionViewLayoutAttributes *attr = [attributes copy];
//        attr.center = CGPointMake(160, attributes.center.y-200);
//        
//        CGFloat centerY = ([self.dataSource sizeForIndexPath:indexPath].height + _interItemSpacing)/2;
//        CGFloat headerHeight = [self.dataSource headerSize].height + _interItemSpacing;
//        attr.center = CGPointMake(160, centerY+headerHeight);
//        NSLog(@"!!attributes: %@ %@",[self printRect:attributes.frame], [self printCenter:attributes.center]);
//        return attr;
//    }
    NSLog(@"attributes: %@ %@",[self printRect:attributes.frame], [self printCenter:attributes.center]);
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' row: %i section: %i",[self class],NSStringFromSelector(_cmd),indexPath.row, indexPath.section);
    
    UICollectionViewLayoutAttributes *attributes = [[self.scrollLayoutInformation objectForKey:@"headerInfo"] objectForKey:indexPath];
    if (!attributes) {
        CGFloat centerY = ([self.dataSource headerSize].height + interItemSpacing)/2;
        CGFloat height = [self.dataSource headerSize].height + interItemSpacing;
        CGFloat multiplier = indexPath.row*(indexPath.section+1);
        
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Header" withIndexPath:indexPath];
        attributes.size = [self.dataSource headerSize];
        attributes.center = CGPointMake(160, centerY+height*multiplier);
    }
    
//    if (self.selectedIndex) {
//        //put cell at top
//        UICollectionViewLayoutAttributes *attr = [attributes copy];
//        CGFloat centerY = ([self.dataSource headerSize].height + _interItemSpacing)/2;
//        attr.center = CGPointMake(160, centerY);
//        NSLog(@"!!!attributes: %@ %@",[self printRect:attributes.frame], [self printCenter:attributes.center]);
//        return attr;
//    }
    NSLog(@"attributes: %@ %@",[self printRect:attributes.frame], [self printCenter:attributes.center]);
    return attributes;
 }
















-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' %@",[self class],NSStringFromSelector(_cmd),updateItems);
    [super prepareForCollectionViewUpdates:updateItems];
}

// called inside an animation block after the update
- (void)finalizeCollectionViewUpdates
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    [super finalizeCollectionViewUpdates];
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' row: %i section: %i",[self class],NSStringFromSelector(_cmd),itemIndexPath.row, itemIndexPath.section);
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@' row: %i section: %i",[self class],NSStringFromSelector(_cmd),itemIndexPath.row, itemIndexPath.section);
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
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
    return [NSString stringWithFormat:@"index row: %i section: %i",index.row, index.section];


}


@end
