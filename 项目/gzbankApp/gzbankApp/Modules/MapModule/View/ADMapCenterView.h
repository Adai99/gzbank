//
//  ADMapCenterView.h
//  gzbankApp
//
//  Created by mac on 2018/9/17.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADMapCenterView : UIView
- (void)setDetailTitle:(NSString *)detail;
@property (nonatomic,copy)dispatch_block_t touchLBBlock;
@end
