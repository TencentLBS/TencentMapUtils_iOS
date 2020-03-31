//
//  EntryData.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EntryData.h"
#import <QMapKit/QMapKit.h>

@implementation Cell

@end

@implementation Section

@end

@implementation EntryData

+ (instancetype)constructDefaultEntryData
{
    EntryData *entry = [[EntryData alloc] init];
    entry.title = [NSString stringWithFormat:@"TencentMap Utils Demos %@", QMapServices.sharedServices.sdkVersion];
    NSMutableArray<Section *> *sectionArray = [NSMutableArray array];
    entry.sections = sectionArray;
    
    // Base Map Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"基础功能";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 点聚合 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"点聚合";
            cell.controllerClassName = @"PointClusterViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Route Animation Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"轨迹处理";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 平滑移动 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"平滑移动";
            cell.controllerClassName = @"SmoothMoveViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    return entry;
}

@end
