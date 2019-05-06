//
//  EntryData.m
//  QMapSDKUtilsDemo
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "EntryData.h"

@implementation Cell

@end

@implementation Section

@end

@implementation EntryData

+ (instancetype)constructDefaultEntryData
{
    EntryData *entry = [[EntryData alloc] init];
    entry.title = @"MapUtils Demo";
    
    NSMutableArray<Section *> *sectionArray = [NSMutableArray array];
    entry.sections = sectionArray;
    
    {
        Section *section = [[Section alloc] init];
        section.title = @"平滑移动";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 基础导航
        {
            Cell *cell = [[Cell alloc] init];
            cell.title = @"平滑移动";
            cell.controllerClassName = @"AnnotationAnimatorViewController";
            [cellArray addObject:cell];
        }
    }
    
    return entry;
}

@end
