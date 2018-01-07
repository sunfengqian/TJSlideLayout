//
//  TJYSlideLayout.m
//  TJYSlideDemo
//
//  Created by TJSlide on 2018/1/3.
//  Copyright © 2018年 TJSlide. All rights reserved.
//

#import "TJSlideLayout.h"

#define kBottomItemCenterYOffset 40
#define kMininumZoomScale 0.9
#define kSlideToNextRatio 0.5
#define kLastPageVisibleRatio 0.7

@interface TJSlideLayout ()
{
    CGFloat _collectionWidth;
    CGFloat _collectionHeight;
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    NSInteger _itemCount;
    CGFloat _bottomItemCenterYOffset;
    CGFloat _mininumVelocity;
    CGFloat _pageHeight;
    NSInteger _realVivibleCount;
    NSMutableArray<UICollectionViewLayoutAttributes *> *_attArray;
}

@end

@implementation TJSlideLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.visibleCount = 3;
        _itemTopInset = 10;
        _itemSize = CGSizeZero;
        _itemBottomOffset = 15;
        _mininumVelocity = 0.3;
        _attArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionView.decelerationRate = 0;
    _collectionHeight = CGRectGetHeight(self.collectionView.bounds);
    _collectionWidth = CGRectGetWidth(self.collectionView.bounds);
    _itemHeight = self.itemSize.height;
    _itemWidth = self.itemSize.width;
    _pageHeight = _itemHeight + _itemTopInset;
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    _bottomItemCenterYOffset = _itemBottomOffset + _itemHeight*(1-kMininumZoomScale)/2;
    
}

- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = CGSizeMake(_collectionWidth, _itemCount * _pageHeight + MAX(0, _collectionHeight - _pageHeight));
    return contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<NSIndexPath *> *indexPaths = [self visibleIndexpathWithCollectionViewContentOffset:self.collectionView.contentOffset];
    
    [_attArray removeAllObjects];
    
    NSInteger firstItemRow = indexPaths.firstObject.row;
    
    CGFloat firstItemCenterY = firstItemRow * _pageHeight + _itemHeight/2 + _itemTopInset;
    
    CGFloat rate = ((firstItemRow) * _pageHeight - MAX(self.collectionView.contentOffset.y,0))/_pageHeight;

    rate = MIN(1, MAX(ABS(rate), 0));
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        if (idx == 0) {
            att.center = CGPointMake(_collectionWidth/2, firstItemCenterY);
            att.transform = CGAffineTransformMakeScale(1, 1);
            att.alpha = 1;
        }  else {
            CGFloat centerY = firstItemCenterY + rate *(_pageHeight-_bottomItemCenterYOffset)+idx*_bottomItemCenterYOffset;
            att.center = CGPointMake(_collectionWidth/2, centerY);
            CGFloat scale = (1-kMininumZoomScale)*rate + (kMininumZoomScale-(1-kMininumZoomScale)*(idx-1));
            att.transform = CGAffineTransformMakeScale(scale, scale);
            att.alpha = scale;
            if (idx == _realVivibleCount-1) {
                if (rate > kLastPageVisibleRatio) {
                    att.alpha = (rate-kLastPageVisibleRatio)/(1-kLastPageVisibleRatio)*scale;
                } else {
                    att.alpha = 0;
                }
            }
        }

        [_attArray addObject:att];
    }];
    
    return _attArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    att.size = self.itemSize;
    
    att.zIndex = - indexPath.row;
    
    return att;
}

- (NSArray<NSIndexPath *> *)visibleIndexpathWithCollectionViewContentOffset:(CGPoint)offset {
    
    NSInteger minIndex = (self.collectionView.contentOffset.y) / _pageHeight;
    
    NSInteger maxIndex = MIN(_itemCount-1, minIndex+_realVivibleCount-1);
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = minIndex; i<= maxIndex; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        [arr addObject:ip];
    }
    
    return arr;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat rawPageValue = self.collectionView.contentOffset.y / _pageHeight;
    CGFloat velocityValue = velocity.y;
    
    CGFloat currentPage = 0;
    CGFloat nextPage = 0;

    if (velocityValue > 0.0) {
        currentPage = floor(rawPageValue);
        nextPage = ceil(rawPageValue);
    } else {
        currentPage = ceil(rawPageValue);
        nextPage = floor(rawPageValue);
    }
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocityValue) > _mininumVelocity;
    
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.y = MAX(nextPage * _pageHeight, 0);
    } else {
        CGFloat posY = round(rawPageValue) * _pageHeight;
        posY = MAX(0, posY);
        proposedContentOffset.y = posY;
    }
    
    return proposedContentOffset;
    
}

#pragma mark - Setter

- (void)setVisibleCount:(NSInteger)visibleCount {
    _visibleCount = visibleCount > 0 ? visibleCount : 3;
    _realVivibleCount = _visibleCount + 1;
}

@end
