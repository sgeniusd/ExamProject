//
//  Paper.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"
#import "NSManagedObject+ActiveRecord.h"

@interface Paper : NSManagedObject <PaperDataProtocol>

@end