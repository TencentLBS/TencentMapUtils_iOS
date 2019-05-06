//
//  EntryData.h
//  QMapSDKUtilsDemo
//
//  Created by 薛程 on 2018/11/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *controllerClassName;

@property (nonatomic, assign) BOOL disabled;

@end

@interface Section : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray<Cell *> *cells;

@end

@interface EntryData : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray<Section *> *sections;

+ (instancetype)constructDefaultEntryData;

@end
