//
//  EXPaperCell.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXPaperCell.h"
#import "PaperData.h"

@implementation EXPaperCell

@synthesize paperData=_paperData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [examTitleLabel release];
    [examTypeLabel release];
    [examMSGLabel release];
    [examDurationLabel release];
    [authorLabel release];
    [super dealloc];
}

- (void)setPaperData:(PaperData *)paperData{
    if (_paperData!=paperData) {
        [_paperData release];
        _paperData=[paperData retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    if (examTitleLabel==nil) {
        examTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame)+5, CGRectGetWidth(self.frame)-80, 20)];
        examTitleLabel.textColor=[UIColor blackColor];
        examTitleLabel.textAlignment=UITextAlignmentLeft;
        examTitleLabel.backgroundColor=[UIColor clearColor];
        examTitleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examTitleLabel];
    }
//    examTitleLabel.text=_paperData.title;
    
    if (examTypeLabel==nil) {
        examTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, CGRectGetWidth(self.frame)-120, 20)];
        examTypeLabel.textColor=[UIColor blackColor];
        examTypeLabel.textAlignment=UITextAlignmentLeft;
        examTypeLabel.backgroundColor=[UIColor clearColor];
        examTypeLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examTypeLabel];
    }
    //examTypeLabel.text=[NSString stringWithFormat:@"考试分类：%@",_paperData.title];
    
    if (examDurationLabel==nil) {
        examDurationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examTypeLabel.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, 90, 20)];
        examDurationLabel.textColor=[UIColor blackColor];
        examDurationLabel.textAlignment=UITextAlignmentLeft;
        examDurationLabel.backgroundColor=[UIColor clearColor];
        examDurationLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examDurationLabel];
    }
    //examDurationLabel.text=[NSString stringWithFormat:@"时长：%@",_paperData.title];
    
    if (examMSGLabel==nil) {
        examMSGLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(examTypeLabel.frame), CGRectGetMaxY(examTypeLabel.frame)+5, CGRectGetWidth(self.frame)-10, 20)];
        examMSGLabel.textColor=[UIColor blackColor];
        examMSGLabel.textAlignment=UITextAlignmentLeft;
        examMSGLabel.numberOfLines=0;
        examMSGLabel.backgroundColor=[UIColor clearColor];
        examMSGLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examMSGLabel];
    }
    //examMSGLabel.text=[NSString stringWithFormat:@"考试须知：%@",_paperData.title];
    
//    if (authorLabel==nil) {
//        authorLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+7, CGRectGetWidth(self.frame)-80, 12)];
//        authorLabel.textColor=[UIColor blackColor];
//        authorLabel.textAlignment=UITextAlignmentLeft;
//        authorLabel.backgroundColor=[UIColor clearColor];
//        authorLabel.font=[UIFont systemFontOfSize:12];
//        [self addSubview:authorLabel];
//    }
//    authorLabel.text=_paperData.creator;
}

@end
