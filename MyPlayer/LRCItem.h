//
//  LRCItem.h
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRCItem : NSObject

@property (nonatomic) float time;
@property (nonatomic, copy) NSString *lrc;

//排序方法
-(BOOL)isTimeOlderThanAnother:(LRCItem *)item;
@end

NS_ASSUME_NONNULL_END
