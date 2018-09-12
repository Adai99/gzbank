//
//  ADCustomLIstTableViewCell.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/6.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCustomLIstTableViewCell.h"
#import "ADCustomListModel.h"
@interface ADCustomLIstTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbcreaterName;
@property (weak, nonatomic) IBOutlet UILabel *lbcustomerTypeId;
@property (weak, nonatomic) IBOutlet UILabel *lbfollowerName;
@property (weak, nonatomic) IBOutlet UILabel *lbOrigantionName;


@end
@implementation ADCustomLIstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ADCustomListModel *)model
{
    _model = model;
    self.lbName.text = model.name;
        self.lbcreaterName.text = [NSString stringWithFormat:@"创建人：%@",model.createrName];
    self.lbcustomerTypeId.text = [NSString stringWithFormat:@"用户类型id:%@",model.customerTypeId];
    self.lbfollowerName.text = [NSString stringWithFormat:@"跟随人姓名:%@",model.followerName];
    self.lbOrigantionName.text = [NSString stringWithFormat:@"所属组织:%@",model.organizationName];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
