//
//  SGFunctionRowView.h
//  operation4ios
//
//  Created by sungrow on 2018/6/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFunctionItem.h"
@class SGFunctionRowView;

@protocol SGFunctionRowViewDelegate <NSObject>

- (void)functionRowView:(SGFunctionRowView *)rowView clickIndex:(NSInteger)index;

@end

@interface SGFunctionRowView : UIView

@property (nonatomic, weak) id <SGFunctionRowViewDelegate>rowViewDelegate;

- (void)addArrangedSubview:(SGFunctionItem *)item;
- (void)removeArrangedSubview:(SGFunctionItem *)item;

- (void)addArrangedSubviews:(NSArray<SGFunctionItem *>*)items;
- (void)removeArrangedSubviews:(NSArray<SGFunctionItem *>*)items;

@end
