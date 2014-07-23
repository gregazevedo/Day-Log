//
//  DLGLayout.m
//  Day Log
//
//  Created by Greg Azevedo on 7/22/14.
//  Copyright (c) 2014 dolodev LLC. All rights reserved.
//

#import "DLGLayout.h"

@interface DLGLayout()

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) CGFloat interItemSpacing;

@end

@implementation DLGLayout

-(id)init
{
    self = [super init];
    if (self) {
        CGFloat top = 0;
        CGFloat left = 0;
        CGFloat bottom = 0;
        CGFloat right = 0;
        self.insets = UIEdgeInsetsMake(top,left,bottom,right);
        self.interItemSpacing = 30;
    }
    return self;
}

-(void)prepareLayout
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    [super prepareLayout];
    
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerInformation = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath;
    
    
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Header" withIndexPath:indexPath];
        [headerInformation setObject:headerAttributes forKey:@"headerInfo"];
        
        NSInteger numItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItemsInSection; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
        }
    }
    [layoutInformation setObject:cellInformation forKey:@"cellInfo"];
    self.layoutInformation = layoutInformation;
}

-(CGSize)collectionViewContentSize
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    CGFloat spacedHeight = [self.layoutDataSource averageItemSize].height + _interItemSpacing;
    CGFloat width = [self.layoutDataSource averageItemSize].width + self.insets.left + self.insets.right;
    CGFloat headerHeight = [self.layoutDataSource headerSize].height;
    
    NSInteger numItems = 0;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++) {
        numItems += [self.collectionView numberOfItemsInSection:section];
    }
    CGFloat height = numItems * (spacedHeight + _insets.top + _insets.bottom) + numSections * headerHeight;
    return CGSizeMake(width, height);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for(NSString *key in self.layoutInformation) {
        NSDictionary *attributesDict = [self.layoutInformation objectForKey:key];
        for(NSIndexPath *key in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = [attributesDict objectForKey:key];
            if(CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes];
            }
        }
    }
    return myAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    UICollectionViewLayoutAttributes *attributes = [[self.layoutInformation objectForKey:@"cellInfo"] objectForKey:indexPath];
    if (!attributes) {
        CGFloat centerY = ([self.layoutDataSource sizeForIndexPath:indexPath].height + _interItemSpacing)/2;
        CGFloat height = [self.layoutDataSource sizeForIndexPath:indexPath].height + _interItemSpacing;
        CGFloat multiplier = (indexPath.row+1)*(indexPath.section+1);
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = [self.layoutDataSource sizeForIndexPath:indexPath];
        attributes.center = CGPointMake(160, centerY+height*multiplier);
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    
    UICollectionViewLayoutAttributes *attributes = [[self.layoutInformation objectForKey:@"headerInfo"] objectForKey:indexPath];
    if (!attributes) {
        CGFloat centerY = ([self.layoutDataSource headerSize].height + _interItemSpacing)/2;
        CGFloat height = [self.layoutDataSource headerSize].height + _interItemSpacing;
        CGFloat multiplier = (indexPath.row+1)*(indexPath.section+1);

        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Header" withIndexPath:indexPath];
        attributes.size = [self.layoutDataSource headerSize];
        attributes.center = CGPointMake(160, centerY+height*multiplier);
    }
    return attributes;

 }

@end
