//
//  KGHomePageMusicTableViewCell.m
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import "KGHomePageMusicTableViewCell.h"

@implementation KGHomePageMusicTableViewCell
+(instancetype)homePageMusicTableViewCellWithTableView:(UITableView *)tableView{
    static NSString*ID=@"HomelistCell";
    KGHomePageMusicTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];//查有没有重复利用的cell 纯代码要用dequeueReusableCellWithIdentifier
    if (cell==nil) {
        cell=[[KGHomePageMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //如果没有重复利用的cell 则再创建一个新的cell
    }
    cell.backgroundColor=[UIColor clearColor];
    //cell.textLabel.text=@"aaa"; 每一句的内容根据模型而来 
    cell.textLabel.textColor=[UIColor whiteColor];//设置cell的背景为透明
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置点击没有背景灰色
    
    
    return cell;
}
-(void)setStatus:(KGMusicCellStatus *)status{
    if (status.selected) {
        self.textLabel.textColor=[UIColor orangeColor];
    }else{
        self.textLabel.textColor=[UIColor whiteColor];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
