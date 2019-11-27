//
//  OBCycleView.h
//  OBCycleView
//
//  Created by 李杨 on 2019/11/5.
//  Copyright © 2019 OB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBPageControl.h"


NS_ASSUME_NONNULL_BEGIN

@class OBCycleView;

@protocol OBCycleViewDelegate <NSObject>
@optional
- (void)oBCycleView:(OBCycleView *)cycleView itemIndex:(NSInteger)index;

@end
@interface OBCycleView : UIView

- (instancetype)initWithFrame:(CGRect)frame pageControl:(OBPageControl *)pageControl;
/** 网络图片 url string 数组 */
@property (nonatomic, copy) NSArray * imagesArray;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, weak) id<OBCycleViewDelegate> delegate;
@property (nonatomic, assign) CGFloat space;
@end

NS_ASSUME_NONNULL_END
