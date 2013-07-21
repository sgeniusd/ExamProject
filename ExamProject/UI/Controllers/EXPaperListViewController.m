//
//  EXPaperListViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXPaperListViewController.h"
#import "EXListView.h"
#import "EXNetPaperCell.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"
#import "EXNetDataManager.h"
#import "EXDownloadManager.h"
//#import "ASIHTTPRequest.h"

@interface EXPaperListViewController ()<UITableViewDataSource,UITableViewDelegate,EXNetPaperDelegate>

@end

@implementation EXPaperListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_paperListView release];
    [_netPaperList release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"网络题库";
    self.view.backgroundColor=[UIColor whiteColor];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationItem.rightBarButtonItem= refreshButton;
    
    if (_netPaperList==nil) {
        _netPaperList=[[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:NOTIFICATION_PAPERS_DOWNLOAD_FINISH object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_paperListView==nil) {
        _paperListView=[[EXListView alloc] initWithFrame:self.view.frame];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_paperListView];
    }
    
    //请求数据
    if ([EXNetDataManager shareInstance].netPaperDataArray==nil || [EXNetDataManager shareInstance].netPaperDataArray.count==0) {
        [self fetchData];
    }else{
        [_netPaperList removeAllObjects];
        [_netPaperList addObjectsFromArray:[EXNetDataManager shareInstance].netPaperDataArray];
        
        [_paperListView refresh];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按钮点击事件
- (void)backwardItemClicked:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshItemClicked:(id)sender{
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *components=[NET_PAPERDATA_URL componentsSeparatedByString:@"/"];
    if (components && components.count>0) {
        destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinatePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:destinatePath error:nil];
    }
    //刷新列表    
    [self fetchData];
}

#pragma mark 列表数据请求
- (void)fetchData{
    [[EXDownloadManager shareInstance] downloadPaperList];
}

- (void)refreshList:(NSNotification *)notification{
    [_netPaperList removeAllObjects];
    [_netPaperList addObjectsFromArray:[EXNetDataManager shareInstance].netPaperDataArray];
    
    [_paperListView refresh];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _netPaperList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXNetPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXNetPaperCell alloc] init] autorelease];
        cell.delegate=self;
        if (indexPath.row<_netPaperList.count) {
            cell.paperData=[_netPaperList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //与点击下载按钮一样：先判断是否下载过，如果没有就去下载
    if (indexPath.row<_netPaperList.count) {
        id  paper=[_netPaperList objectAtIndex:indexPath.row];
        [[EXDownloadManager shareInstance] downloadPaper:paper];
    }
}


#pragma mark EXNetPaperDelegate
- (void)downloadNetPaper:(id)paper{
    [[EXDownloadManager shareInstance] downloadPaper:paper];
}

@end
