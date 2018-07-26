//
//  SGFunctionItem.m
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import "SGFunctionItem.h"

@interface SGFunctionItem ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SGFunctionItem

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
    }
    return _tapGesture;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.textColor = [UIColor colorWithRed:113/255 green:113/255 blue:113/255 alpha:113/255];
        [_label setContentHuggingPriority:900 forAxis:UILayoutConstraintAxisVertical];
    }
    return _label;
}

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text {
    return [self initWithImage:image touchDownImage:nil text:text];
}

- (instancetype)initWithImage:(UIImage *)image touchDownImage:(UIImage *)downImage text:(NSString *)text {
    if (self = [super init]) {
        [self createView];
        [self.button setImage:image forState:UIControlStateNormal];
        [self.button setImage:downImage forState:UIControlStateHighlighted];
        self.label.text = text;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizer:self.tapGesture];
    [self addSubview:self.button];
    [self addSubview:self.label];
    
    self.button.translatesAutoresizingMaskIntoConstraints = false;
    [self.button.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
    [self.button.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.button.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
    self.label.translatesAutoresizingMaskIntoConstraints = false;
    [self.label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8].active = YES;
    [self.label.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.label.topAnchor constraintEqualToAnchor:self.button.bottomAnchor constant:4].active = YES;
    
    [self addTarget:self action:@selector(clickItem:)];
}

/**
 添加点击监听事件

 @param target 目标对象
 @param action 事件
 */
- (void)addTarget:(id)target action:(SEL)action {
    if ([[self.button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(action)]) {
        return;
    }
    [self.tapGesture addTarget:target action:action];
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 移除点击监听事件
 
 @param target 目标对象
 @param action 事件
 */
- (void)removeTarget:(id)target action:(SEL)action {
    if (![[self.button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(action)]) {
        return;
    }
    [self.tapGesture removeTarget:target action:action];
    [self.button removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickItem:(id)obj {
    if (self.clickItemBlock) {
        self.clickItemBlock(self);
    }
}

@end
