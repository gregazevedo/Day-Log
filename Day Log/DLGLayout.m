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
    
    NSIndexPath *indexPath;
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    for(NSInteger item = 0; item < numItems; item++){
        
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [cellInformation setObject:attributes forKey:indexPath];
    }
    [layoutInformation setObject:cellInformation forKey:@"cellInfo"];
    self.layoutInformation = layoutInformation;
}

-(CGSize)collectionViewContentSize
{
    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
    
    CGFloat spacedHeight = [self.layoutDataSource averageItemSize].height + _interItemSpacing;
    CGFloat width = [self.layoutDataSource averageItemSize].width + self.insets.left + self.insets.right;
    
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    CGFloat height = numItems * (spacedHeight + _insets.top + _insets.bottom);
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
        
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = [self.layoutDataSource sizeForIndexPath:indexPath];
        
        CGFloat multiplier = indexPath.row;
        attributes.center = CGPointMake(160, centerY+height*multiplier);
    }
    return attributes;
}

//-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if(QUICKDEBUG) NSLog(@"{[]} %@ '%@'",[self class],NSStringFromSelector(_cmd));
//    
//    CGFloat centerY = [self.layoutDataSource totalQuestionSize].height/2;
//    CGFloat height = [self.layoutDataSource totalQuestionSize].height;
//    CGFloat multiplier = indexPath.row;
//    if ([kind isEqualToString:@"Title"]) {
//        UICollectionViewLayoutAttributes *titleAttributes = [[self.layoutInformation objectForKey:@"titleInfo"] objectForKey:indexPath];
//        if (!titleAttributes) {
//            CGFloat offset = [self.layoutDataSource itemSize].height/2+[self.layoutDataSource titleSize].height/2;
//            titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Title" withIndexPath:indexPath];
//            titleAttributes.size = [self.layoutDataSource titleSize];
//            titleAttributes.center = CGPointMake(160, centerY+height*multiplier-offset);
//            titleAttributes.zIndex = 1;
//            titleAttributes.alpha = 0.7;
//        }
//        return titleAttributes;
//    }
//    else if ([kind isEqualToString:@"Response"]) {
//        UICollectionViewLayoutAttributes *responseAttributes = [[self.layoutInformation objectForKey:@"responseInfo"] objectForKey:indexPath];
//        if (!responseAttributes) {
//            CGFloat offset = [self.layoutDataSource itemSize].height/2+[self.layoutDataSource responseSize].height/2;
//            responseAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"Response" withIndexPath:indexPath];
//            responseAttributes.size = [self.layoutDataSource responseSize];
//            responseAttributes.center = CGPointMake(160, centerY+height*multiplier+offset);
//            responseAttributes.zIndex = 2;
//            responseAttributes.alpha = 0.7;
//        }
//        return responseAttributes;
//    }
//    return nil;
//}

@end
