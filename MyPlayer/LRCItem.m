//
//  LRCItem.m
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import "LRCItem.h"

@implementation LRCItem
- (BOOL)isTimeOlderThanAnother:(LRCItem *)item{
    return self.time > item.time;
    //歌词排序
}
@end
