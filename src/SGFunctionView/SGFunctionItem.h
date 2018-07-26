//
//  SGFunctionItem.h
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFunctionItem : UIView

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text;
- (instancetype)initWithImage:(UIImage *)image touchDownImage:(UIImage *)downImage text:(NSString *)text;

/** 按钮 */
@property (nonatomic, strong) UIButton *button;
/** 文本 */
@property (nonatomic, strong) UILabel *label;
/** 点击回调 */
@property (nonatomic, copy) void (^clickItemBlock)(SGFunctionItem *item);

- (void)addTarget:(id)target action:(SEL)action;
- (void)removeTarget:(id)target action:(SEL)action;

@end
