//
//  OBCycleViewCell.h
//  OBCycleView
//
//  Created by 李杨 on 2019/11/5.
//  Copyright © 2019 OB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCycleViewCell : UIView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIImageView *contentIV;

- (void)fillElementWithImgString:(NSString *)imgUrl;
@end

NS_ASSUME_NONNULL_END
