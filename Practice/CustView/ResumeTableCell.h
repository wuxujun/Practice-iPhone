//
//  ResumeTableCell.h
//  Practice
//
//  Created by xujunwu on 16/4/3.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import "HSwipeTableCell.h"

@interface ResumeTableCell : HSwipeTableCell

@property(nonatomic,strong) UILabel*    title;
@property(nonatomic,strong) UILabel*    content;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
