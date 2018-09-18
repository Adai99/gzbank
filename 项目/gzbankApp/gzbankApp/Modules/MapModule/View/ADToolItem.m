//
//  ADToolItem.m
//  gzbankApp
//
//  Created by mac on 2018/9/18.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADToolItem.h"
@interface ADToolItem ()
@property (nonatomic,strong)UIImageView *imageIcon;
@property (nonatomic,strong)UILabel *lbContent;
@end
@implementation ADToolItem

- (instancetype)initWithImageName:(NSString *)imageName Title:(NSString *)titleName
{
    self = [super init];
    if (self) {
        self.imageIcon.image = [UIImage imageNamed:imageName];
        self.lbContent.text = titleName;
        [self __buildUI];
    }
    return self;
}
- (void)__buildUI
{
    [self addSubview:self.imageIcon];
    [self addSubview:self.lbContent];
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.mas_centerY);
    }];
}
- (UIImageView *)imageIcon
{
    if (_imageIcon == nil) {
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.backgroundColor = [UIColor greenColor];
    }
    return _imageIcon;
}
- (UILabel *)lbContent
{
    if (_lbContent == nil) {
        _lbContent = [[UILabel alloc]init];
        _lbContent.backgroundColor = [UIColor orangeColor];
    
    }
    return _lbContent;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
