//
//  SlideCollectionViewCell.m
//  TJSlideCardDemo
//
//  Created by TJSlide on 2018/1/5.
//  Copyright © 2018年 TJSlide. All rights reserved.
//

#import "SlideCollectionViewCell.h"

@interface SlideCollectionViewCell ()

@end

@implementation SlideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [UIImageView new];
        self.imageView.layer.cornerRadius = 8;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

@end
