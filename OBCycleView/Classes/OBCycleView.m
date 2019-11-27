//
//  OBCycleView.m
//  OBCycleView
//
//  Created by 李杨 on 2019/11/5.
//  Copyright © 2019 OB. All rights reserved.
//

#import "OBCycleView.h"
#import "OBCycleViewCell.h"


@interface OBCycleView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, weak) NSTimer         * autoTimer;
@property (nonatomic, assign) CGFloat     itemWidth;

// left middle right 3 View
@property (nonatomic, strong) OBCycleViewCell * leftView;
@property (nonatomic, strong) OBCycleViewCell * middleView;
@property (nonatomic, strong) OBCycleViewCell * rightView;

@property (nonatomic, strong) OBPageControl *pageControl;
//
@property (nonatomic, assign) NSInteger     rightIndex;
@property (nonatomic, assign) NSInteger     middleIndex;
@property (nonatomic, assign) NSInteger     leftIndex;

//
@property (nonatomic, assign) NSInteger     itemCount;

@end
@implementation OBCycleView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame pageControl:(OBPageControl *)pageControl {
    self = [super initWithFrame:frame];
    if (self) {
        self.pageControl = pageControl;
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}
#pragma mark - tap 点击事件
- (void)tapClick:(UITapGestureRecognizer*)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(oBCycleView:itemIndex:)]) {
        [self.delegate oBCycleView:self itemIndex:self.middleIndex];
    }
    
}


#pragma mark - reload data method
- (void)reloadCycleData {
    if (self.imagesArray.count <=0) {
        return;
    }
    [self.leftView fillElementWithImgString:self.imagesArray[_leftIndex]];
    [self.middleView fillElementWithImgString:self.imagesArray[_middleIndex]];
    [self.rightView fillElementWithImgString:self.imagesArray[_rightIndex]];
}

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    self.itemCount = imagesArray.count;
    self.pageControl.pageCount = imagesArray.count;
    [self loadConfigData];
    [self reloadCycleData];
    //
    [self timerStart];
}
#pragma mark - private
- (void)setupData {
    self.space = 0;
    self.autoScroll = YES;
    [self loadConfigData];
    
//    [self reloadCycleData];
    
}
- (void)loadConfigData {
    self.itemWidth = self.bounds.size.width-self.space*4;
    self.itemCount = self.imagesArray.count;
    if (self.itemCount ==1) {
        self.mainScrollView.scrollEnabled = NO;
    }else
        self.mainScrollView.scrollEnabled = YES;
    
    if (self.itemCount >2) {
        self.leftIndex   =self.imagesArray.count - 1;
        self.middleIndex =0;
        self.rightIndex  =1;
    } else if(self.itemCount == 2) {
        self.leftIndex   =1;
        self.middleIndex =0;
        self.rightIndex  =1;
    } else if(self.itemCount == 1) {
        self.leftIndex   =0;
        self.middleIndex =0;
        self.rightIndex  =0;
    }
    self.pageControl.pageCount = self.imagesArray.count;
    self.pageControl.selectIndex = self.middleIndex;
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    if (space > 0.001) {
        [self loadConfigData];
        [self setupLayout];
    }
}
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (!autoScroll) {
        [self timerStop];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    self.leftView.placeholderImage = placeholderImage;
    self.middleView.placeholderImage = placeholderImage;
    self.rightView.placeholderImage = placeholderImage;
    
}
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainScrollView];
    [self addSubview:self.pageControl];
    
    
    self.leftView = [[OBCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.leftView];
    
    
    self.middleView = [[OBCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.middleView];
    
    // 在中间页面添加手势
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    tap.delegate = self;
    [self.middleView addGestureRecognizer:tap];
    
    
    
    self.rightView = [[OBCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.rightView];
}

- (void)setupLayout {
    self.itemWidth = self.bounds.size.width-self.space*4;
    CGFloat k_space = self.space;
    CGFloat k_w = self.itemWidth;
    self.mainScrollView.contentSize = CGSizeMake(k_w * 3+ k_space*2, self.bounds.size.height);
    self.leftView.frame = CGRectMake(0, 0, k_w, self.bounds.size.height);
    CGFloat m_x = CGRectGetMaxX(self.leftView.frame) + k_space;
    self.middleView.frame = CGRectMake(m_x, 0, k_w, self.bounds.size.height);
    CGFloat r_x = CGRectGetMaxX(self.middleView.frame) + k_space;
    self.rightView.frame = CGRectMake(r_x, 0, k_w, self.bounds.size.height);
    self.mainScrollView.contentOffset = CGPointMake(-k_space + k_w, 0);
}


- (void)reloadUI {
    //像左滑动
    if (self.mainScrollView.contentOffset.x >= self.itemWidth -1) {
        self.rightIndex  ++;
        self.middleIndex ++;
        self.leftIndex   ++;
        if (self.leftIndex > self.itemCount-1)   {self.leftIndex = 0;}
        if (self.middleIndex > self.itemCount-1) {self.middleIndex = 0;}
        if (self.rightIndex > self.itemCount-1)  {self.rightIndex = 0;}
            
    } else if (self.mainScrollView.contentOffset.x <= 1) {
        self.leftIndex   --;
        self.middleIndex --;
        self.rightIndex  --;
        if (self.leftIndex<0)   {self.leftIndex = self.itemCount-1;}
        if (self.middleIndex<0) {self.middleIndex = self.itemCount-1;}
        if (self.rightIndex<0)  {self.rightIndex = self.itemCount-1;}
    }
    
    self.pageControl.selectIndex = self.middleIndex;
    //先后执行，防止闪一下
    [self reloadCycleData];
    [self.mainScrollView setContentOffset:CGPointMake(self.itemWidth-self.space, 0) animated:NO];
}
- (void)timeEvent:(NSTimer*)timer {
    if (!self.autoScroll) {
        [timer invalidate];
        [self timerStop];
    }
    //使用 UIView 动画使 view 滑行到终点
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(self.itemWidth*2, 0) animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            [self reloadUI];
        }
    }];
    
}

- (void)timerStart {
    if (!self.autoScroll) {
        return;
    }
    [self timerStop];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoTimer forMode:NSRunLoopCommonModes];
}

- (void)timerStop {
    [self.autoTimer invalidate];
    self.autoTimer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self timerStop];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self timerStart];
    } else {
        [self timerStop];
    }
    float view_w = self.itemWidth;
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    BOOL left = point.x < 0;
    CGFloat totleSpace = 0;
    CGFloat final_x = 0;
    //像左滑动
    if (self.mainScrollView.contentOffset.x > view_w ) {
        if (left) {
            final_x = view_w *2;
        } else {
            final_x = view_w - self.space;
        }
    } else if (self.mainScrollView.contentOffset.x <= view_w -1) {
        totleSpace = view_w;
        if (left) {
            final_x = view_w - self.space;
        } else {
            final_x = 0 - self.space;
        }
    }
    
    CGPoint finalPoint = CGPointMake(final_x, 0);
    
    //使用 UIView 动画使 view 滑行到终点
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:finalPoint animated:NO];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self reloadUI];
                         }
                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (((NSInteger)targetContentOffset->x % (NSInteger)self.itemWidth == 0)) {
        return;
    }
    
    [self scrollViewWillBeginDecelerating:scrollView];
}


#pragma mark - setter&getter
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        [_mainScrollView setShowsHorizontalScrollIndicator:NO];
        [_mainScrollView setShowsVerticalScrollIndicator:NO];
    }
    return _mainScrollView;
}

- (OBPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[OBPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
    }
    return _pageControl;
}


@end
