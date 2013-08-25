//
//  TopicData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "TopicData.h"
#import "Topic.h"
#import "AnswerData.h"
#import "Answer.h"

@implementation TopicData

@synthesize topicId;
@synthesize topicQuestion;
@synthesize topicType;
@synthesize topicAnalysis;
@synthesize topicValue;
@synthesize topicImage;

- (id)initWithTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
        self.topicId = topic.topicId;
        self.topicQuestion = topic.topicQuestion;
        self.topicType = topic.topicType;
        self.topicAnalysis = topic.topicAnalysis;
        self.topicValue = topic.topicValue;
        self.topicImage = topic.topicImage;
        
        //将数据以AnswerData的形式传递出去
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"content" ascending:YES];
        NSArray *sortedArray = [topic.answers sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        [sortDescriptor release];
        
        NSMutableArray *answerDataArray = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (Answer *answer in sortedArray) {
            AnswerData *answerData = [[AnswerData alloc]initWithAnswer:answer];
            [answerDataArray addObject:answerData];
            [answerData release];
        }
        self.answers = answerDataArray;
    }
    return self;
}

- (void)dealloc
{
    [topicId release];
    [topicQuestion release];
    [topicType release];
    [topicAnalysis release];
    [topicValue release];
    [topicImage release];
    
    [_answers release];
    
    [super dealloc];
}

@end
