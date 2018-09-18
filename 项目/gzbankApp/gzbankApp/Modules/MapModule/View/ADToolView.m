//
//  ADToolView.m
//  gzbankApp
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADToolView.h"
#import "ADToolItem.h"
@interface ADToolView ()
@end
@implementation ADToolView
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *aryIndex = [@[@"百度",@"介绍",@"添加"]mutableCopy];
        for (int i = 0; i<aryIndex.count; i++) {
            ADToolItem *toolItem = [[ADToolItem alloc]initWithImageName:@"" Title:aryIndex[i]];
            toolItem.tag = i;
            [self addSubview:toolItem];
            toolItem.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
            [toolItem addGestureRecognizer:tap];
            [toolItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.equalTo(self);
                make.top.equalTo(@(44*i));
                make.height.equalTo(@44);
            }];
        }
    }
    return self;
}
- (void)actionTap:(UITapGestureRecognizer *)tap
{
    self.didSelectedBtn(tap.view.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
