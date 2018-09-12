//
//  ADCollectionTableViewCell.m
//  gzbankApp
//
//  Created by 黄志航 on 2018/9/11.
//  Copyright © 2018年 黄志航. All rights reserved.
//

#import "ADCollectionTableViewCell.h"
@interface ADCellBtn ()
@end
@implementation ADCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
+ (CGFloat)heightFrom:(NSMutableArray *)aryCell
{
    int addhang = aryCell.count%3>0?1:0;
    int hang = (int)aryCell.count/3+addhang;
    
    return (screenWidth - 10*4)/3*hang+(hang+1)*10;
}
- (void)setAryCell:(NSMutableArray <ADCustomCommitGroupModel *>*)aryCell
{
    _aryCell = aryCell;
    CGFloat CellIndexWidthEdge = 10;
    CGFloat cellIndexHeightEdge = 10;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<aryCell.count; i++) {
        CGFloat width = (screenWidth - CellIndexWidthEdge*4)/3;
        CGFloat x = (i%3+1)*CellIndexWidthEdge+width*(i%3);
        CGFloat y = (i/3+1)*cellIndexHeightEdge+i/3*(width);
        CGFloat height = width;
        ADCellBtn *cellBtn = [[ADCellBtn alloc]init];
        cellBtn.frame = CGRectMake(x, y, width, height);
        cellBtn.btn.tag = i;
        ADCustomCommitGroupModel *model = aryCell[i];
        cellBtn.lbTitle.text = model.name;
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiCDNPrefix,model.icon]];
        [cellBtn.viewIcon sd_setImageWithURL:iconUrl placeholderImage:nil];
        [self.contentView addSubview:cellBtn];
        [cellBtn __buildUI];

        WeakSelf
        cellBtn.clickBlock = ^(ADCellBtn *btn) {
            StrongSelf
            if (strongSelf.btnClick) {
                strongSelf.btnClick(btn);
            }
        };
        
    }
}
#pragma mark ---PropertyList

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
