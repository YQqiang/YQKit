//
//  SGFunctionView.h
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFunctionRowView.h"
@class SGFunctionView;

@protocol SGFunctionViewDelegate <NSObject>

- (void)functionView:(SGFunctionView *)rowView clickIndexPath:(NSIndexPath *)indexPath;

@end

@interface SGFunctionView : UIView

@property (nonatomic, weak) id <SGFunctionViewDelegate>viewDelegate;

- (void)addArrangedSubview:(SGFunctionRowView *)rowView;
- (void)removeArrangedSubview:(SGFunctionRowView *)rowView;

- (void)addArrangedSubviews:(NSArray<SGFunctionRowView *>*)rowViews;
- (void)removeArrangedSubviews:(NSArray<SGFunctionRowView *>*)rowViews;

- (void)addArrangedItems:(NSArray<NSArray<SGFunctionItem *>*>*)items;

@end
