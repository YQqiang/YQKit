//
//  SGFunctionView.m
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import "SGFunctionView.h"

@interface SGFunctionView ()<SGFunctionRowViewDelegate>

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation SGFunctionView

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.spacing = 0;
        _stackView.axis = UILayoutConstraintAxisVertical;
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

- (void)addArrangedSubview:(SGFunctionRowView *)rowView {
    [self.stackView addArrangedSubview:rowView];
    rowView.hidden = NO;
    [self updateStackViewHeight];
    if (!rowView.rowViewDelegate) {
        rowView.rowViewDelegate = self;
    }
}

- (void)removeArrangedSubview:(SGFunctionRowView *)rowView {
    [self.stackView removeArrangedSubview:rowView];
    rowView.hidden = YES;
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

- (void)addArrangedSubviews:(NSArray<SGFunctionRowView *>*)rowViews {
    [rowViews enumerateObjectsUsingBlock:^(SGFunctionRowView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addArrangedSubview:obj];
    }];
}

- (void)removeArrangedSubviews:(NSArray<SGFunctionRowView *>*)rowViews {
    [rowViews enumerateObjectsUsingBlock:^(SGFunctionRowView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeArrangedSubview:obj];
    }];
}

- (void)addArrangedItems:(NSArray<NSArray<SGFunctionItem *>*>*)items {
    for (NSArray <SGFunctionItem *>*subItems in items) {
        SGFunctionRowView *rowView = [[SGFunctionRowView alloc] init];
        [rowView addArrangedSubviews:subItems];
        [self addArrangedSubview:rowView];
    }
}

#pragma mark - SGFunctionRowViewDelegate
- (void)functionRowView:(SGFunctionRowView *)rowView clickIndex:(NSInteger)index {
    NSInteger row = [[self.stackView arrangedSubviews] indexOfObject:rowView];
    if ([self.viewDelegate conformsToProtocol:@protocol(SGFunctionViewDelegate)]) {
        if ([self.viewDelegate respondsToSelector:@selector(functionView:clickIndexPath:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:row];
            [self.viewDelegate functionView:self clickIndexPath:indexPath];
        }
    }
}

@end
