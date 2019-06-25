//
//  LRCEngine.h
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRCItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface LRCEngine : NSObject

-(instancetype)initWithFile:(NSString *)fileName;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *albume;
@property (nonatomic, strong) NSString *title;
-(void)getCurrentLRCInLRCArray:(void(^)(NSArray *lrcArray,int currectIndex))handle atTime:(float)time;
//是歌词引擎的核心方法，通过传入一个时间点的值来获取当前对应的歌词，在handle函数块中将传入两个参数，一个是已经按时间s排序的每行歌词 一个是当前对应歌词在数组中的位置

@end

NS_ASSUME_NONNULL_END
