//
//  ADMapCenterView.m
//  gzbankApp
//
//  Created by mac on 2018/9/17.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADMapCenterView.h"
@interface ADMapCenterView ()
@property (nonatomic,strong)UILabel *lbDetails;
@property (nonatomic,strong)UIImageView *imageCenter;
@property (nonatomic,assign)BOOL isShowDetail;
@end
@implementation ADMapCenterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self __buildUI];
    }
    return self;
}
- (void)__lbTouch
{
    self.touchLBBlock();
}
- (void)__buildUI
{
    [self addSubview:self.lbDetails];
    [self addSubview:self.imageCenter];
    
}
- (void)setDetailTitle:(NSString *)detail
{
    self.lbDetails.text = detail;
    self.imageCenter.frame = CGRectMake(self.bounds.size.width/2-14, self.bounds.size.height/2+18, 28, 35);
    self.lbDetails.frame = CGRectMake(self.bounds.size.width/2-(screenWidth -200)/2, self.bounds.size.height/2-32, screenWidth-200, 64);
}
- (UILabel *)lbDetails
{
    if (_lbDetails == nil) {
        _lbDetails = [[UILabel alloc]init];
        _lbDetails.backgroundColor = [UIColor orangeColor];
        _lbDetails.numberOfLines = 0;
        _lbDetails.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(__lbTouch)];
        [_lbDetails addGestureRecognizer:tap];
    }
    return _lbDetails;
}
- (UIImageView *)imageCenter
{
    if (_imageCenter == nil) {
        _imageCenter = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isShowDetail)];
        _imageCenter.backgroundColor = [UIColor redColor];
        _imageCenter.userInteractionEnabled = YES;
        [_imageCenter addGestureRecognizer:tap];
    }
    return _imageCenter;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
