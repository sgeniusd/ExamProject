//
//  ExamViewController.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXListView;

@interface ExamViewController : UIViewController{
    EXListView              *_paperListView;
    NSMutableArray          *_localPaperList;
}

@end
