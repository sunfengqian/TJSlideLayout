//
//  TJYSlideLayout.h
//  TJYSlideDemo
//
//  Created by TJSlide on 2018/1/3.
//  Copyright © 2018年 TJSlide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJSlideLayout : UICollectionViewLayout

/// item size (default is CGSizeZero)
@property (nonatomic, assign) CGSize itemSize;

/// item可见的个数(default is 3)
@property (nonatomic, assign) NSInteger visibleCount;

/// item top inset(default is 10)
@property (nonatomic, assign) CGFloat itemTopInset;

/// item bottom 与上一个之间的间隔
@property (nonatomic, assign) CGFloat itemBottomOffset;

@end
