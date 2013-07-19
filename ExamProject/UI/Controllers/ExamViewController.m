//
//  ExamViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamViewController.h"
#import "PaperData.h"
#import "DBManager.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    testLabel.backgroundColor = [UIColor greenColor];
    testLabel.text = @"测试测试";
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.font = [UIFont systemFontOfSize:24];
    testLabel.adjustsLetterSpacingToFitWidth = YES;
    testLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:testLabel];
    [testLabel release];
    
    [self testAddPaper];        //添加试卷测试方法(存在会覆盖原来数据)
    
    UIButton *getPaperFromDBBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getPaperFromDBBtn.backgroundColor = [UIColor whiteColor];
    getPaperFromDBBtn.frame = CGRectMake(10, 60, 80, 40);
    [getPaperFromDBBtn setTitle:@"获取试卷" forState:UIControlStateNormal];
    [getPaperFromDBBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getPaperFromDBBtn addTarget:self action:@selector(getDBPaperClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getPaperFromDBBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//测试添加试卷，json从本地读取
- (void)testAddPaper
{
    //解析本地json文件
    NSString *path = [[NSBundle mainBundle]pathForResource:@"hangyeceshi-1" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"result=%@", result);
    
    PaperData *paperData = [[PaperData alloc]init];
    paperData.paperId = [NSNumber numberWithInt:[[result objectForKey:@"id"] intValue]];
    paperData.title = [result objectForKey:@"title"];
    paperData.desc = [result objectForKey:@"description"];
    paperData.creator = [result objectForKey:@"creator"];
    paperData.totalTime = [NSNumber numberWithInt:[[result objectForKey:@"totalTime"] intValue]];
    paperData.totalScore = [NSNumber numberWithInt:[[result objectForKey:@"totalScore"] intValue]];
    paperData.topicCount = [NSNumber numberWithInt:[[result objectForKey:@"topicCount"] intValue]];
    paperData.passingScore = [NSNumber numberWithInt:[[result objectForKey:@"passingScore"] intValue]];
    paperData.eliteScore = [NSNumber numberWithInt:[[result objectForKey:@"eliteScore"] intValue]];
    [DBManager addPaper:paperData];
    [paperData release];
}

- (void)getDBPaperClicked:(id)sender
{
    NSArray *allPaper = [DBManager fetchAllPapersFromDB];
    for (PaperData *pData in allPaper) {
        NSLog(@"pData=%@", pData);
    }    
}

@end