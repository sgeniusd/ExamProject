//
//  EXOptionTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXOptionTopicView.h"

@interface EXOptionTopicView ()<EXCheckBoxDelegate>

@end

@implementation EXOptionTopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshUI{
    [super refreshUI];
//    NSLog(@"option index:%d",self.index);
    //options check view
    NSArray *optionsArray=[self.metaData.answers componentsSeparatedByString:@"|"];
    if (optionsArray) {
        [optionsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (obj) {
                EXCheckOptionView *checkView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(5, idx*45, 40, 40) checked:NO];
                checkView.backgroundColor=[UIColor clearColor];
                checkView.delegate=self;
                checkView.exclusiveTouch=YES;
                checkView.index=idx;
                [answerContainerView addSubview:checkView];
                [checkView release];
                
                UILabel *optionLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkView.frame)+5,idx*45,200,40)];
                optionLabel.textColor=[UIColor blackColor];
                optionLabel.text=obj;
                optionLabel.backgroundColor=[UIColor clearColor];
                optionLabel.textAlignment=UITextAlignmentLeft;
                optionLabel.text=obj;
                [answerContainerView addSubview:optionLabel];
                [optionLabel release];
            }
        }];
        if (answerContainerView.contentSize.height<45*optionsArray.count) {
            answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, 45*optionsArray.count);
        }
    }
}

#pragma mark EXCheckBoxDelegate
- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj{
    EXCheckOptionView *sender=(EXCheckOptionView *)obj;
    NSArray *subViews=[answerContainerView subviews];
    
    if ([self.metaData.type integerValue]==1) {
        //单选:取消其它按纽的选中状态
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                if (item != sender) {
                    ((EXCheckOptionView *)item).checked=NO;
                }
            }
        }
    }
    
    [self updateSelectedResult];
}

@end
