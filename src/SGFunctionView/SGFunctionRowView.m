//
//  SGFunctionRowView.m
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import "SGFunctionRowView.h"

@interface SGFunctionRowView ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation SGFunctionRowView

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.spacing = 0;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _stackView;
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
    [self addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = false;
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
}

- (void)addArrangedSubview:(SGFunctionItem *)item {
    [self.stackView addArrangedSubview:item];
    item.hidden = NO;
    [self updateStackViewHeight];
    if (!item.clickItemBlock) {
        __weak typeof(self) weakSelf = self;
        [item setClickItemBlock:^(SGFunctionItem *item) {
            NSInteger index = [weakSelf.stackView.arrangedSubviews indexOfObject:item];
            if ([weakSelf.rowViewDelegate conformsToProtocol:@protocol(SGFunctionRowViewDelegate)]) {
                if ([weakSelf.rowViewDelegate respondsToSelector:@selector(functionRowView:clickIndex:)]) {
                    [weakSelf.rowViewDelegate functionRowView:weakSelf clickIndex:index];
                }
            }
        }];
    }
}

- (void)removeArrangedSubview:(SGFunctionItem *)item {
    [self.stackView removeArrangedSubview:item];
    item.hidden = YES;
    [self updateStackViewHeight];
}

- (void)updateStackViewHeight {
    CGFloat priority = self.stackView.arrangedSubviews.count == 0 ? 900 : 100;
    [self.stackView removeConstraints:self.stackView.constraints];
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    NSLayoutConstraint *heightAnchor = [self.stackView.heightAnchor constraintEqualToConstant:0];
    heightAnchor.priority = priority;
    heightAnchor.active = YES;
}

- (void)addArrangedSubviews:(NSArray<SGFunctionItem *>*)items {
    [items enumerateObjectsUsingBlock:^(SGFunctionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addArrangedSubview:obj];
    }];
}

- (void)removeArrangedSubviews:(NSArray<SGFunctionItem *>*)items {
    [items enumerateObjectsUsingBlock:^(SGFunctionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeArrangedSubview:obj];
    }];
}

@end
