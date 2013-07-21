//
//  EXDownloadManager.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXDownloadManager.h"
#import "EXNetDataManager.h"
#import "ASIHTTPRequest.h"
#import "PaperData.h"
#import "DBManager.h"

static EXDownloadManager *instance=nil;

@interface EXDownloadManager ()<ASIHTTPRequestDelegate>

@end

@implementation EXDownloadManager

+ (EXDownloadManager *)shareInstance{
    if (instance==nil) {
        instance=[[EXDownloadManager alloc] init];
    }
    return instance;
}

+ (void)destroyInstance{
    [instance release];
    instance=nil;
}

- (id)init{
    self=[super init];
    if (self) {
        //TODO:initializations
        [ASIHTTPRequest setMaxBandwidthPerSecond:0];
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)cancelRequest{
    if (request) {
        [request clearDelegatesAndCancel];
        [request release];
        request=nil;
    }
}

- (void)downloadPaper:(id)paper{
    //判断有没有，如果没有则直接去下载
    NSURL *url = [NSURL URLWithString:[paper objectForKey:@"url"]];
    [self cancelRequest];
    request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *components=[[paper objectForKey:@"url"] componentsSeparatedByString:@"/"];
    if (components && components.count>0) {
        destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
    }
    [request setDownloadDestinationPath:destinatePath];
    [ASIHTTPRequest showNetworkActivityIndicator];
    
    [request startAsynchronous];
}

- (void)downloadPaperList{
    
    NSURL *url=[NSURL URLWithString:NET_PAPERDATA_URL];
    [self cancelRequest];
    request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *components=[NET_PAPERDATA_URL componentsSeparatedByString:@"/"];
    if (components && components.count>0) {
        destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
    }
    
    [request setDownloadDestinationPath:destinatePath];
    [ASIHTTPRequest showNetworkActivityIndicator];
    [request startAsynchronous];
}


#pragma mark 下载回调
- (void)requestFinished:(ASIHTTPRequest *)request{
    [ASIHTTPRequest hideNetworkActivityIndicator];
    //下载成功后的回调
    NSString *requestURL=[request.url absoluteString];
    if ([requestURL isEqualToString:NET_PAPERDATA_URL]) {
        //下载试卷列表
        NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *components=[NET_PAPERDATA_URL componentsSeparatedByString:@"/"];
        if (components && components.count>0) {
            destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
        }
        NSData *data = [NSData dataWithContentsOfFile:destinatePath];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [EXNetDataManager shareInstance].netPaperDataArray=[result objectForKey:@"arrayData"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAPERS_DOWNLOAD_FINISH object:nil];
    }else{
        NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *components=[requestURL componentsSeparatedByString:@"/"];
        if (components && components.count>0) {
            destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
        }
        NSData *paperJson= [NSData dataWithContentsOfFile:destinatePath];
        PaperData *paper=[Utility convertJSONToPaperData:paperJson];
        paper.topics=[Utility convertJSONToTopicData:paperJson];
        [DBManager addPaper:paper];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH object:nil];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [ASIHTTPRequest hideNetworkActivityIndicator];
    //下载失败
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
}

@end
