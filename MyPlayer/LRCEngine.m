//
//  LRCEngine.m
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import "LRCEngine.h"

@implementation LRCEngine
{
    NSMutableArray *_lrcArray;
}

//数组对象的初始化操作
-(instancetype)initWithFile:(NSString *)fileName{
    if (self == [super init]) {
        _lrcArray = [[NSMutableArray alloc] init];
        [self creatDataWithFile:fileName];
    }
    return self;
}
-(void)creatDataWithFile:(NSString *)fileName
{
    //读取文件
    NSString *lrcPath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"lrc"];
    NSError *error;
    NSString *dataStr = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:&error];
    
    NSMutableString *tmpStr = [[NSMutableString alloc] init];
   
    //切割字符串
    NSArray *tmpArray = [dataStr componentsSeparatedByString:@"\r"];//回车
    
    for (int i=0; i<tmpArray.count; i++)
    {
        [tmpStr appendString:tmpArray[i]];
        //将数组数据添加到tmpStr中
    }
    //按照换行符进行字符串切割
    NSArray *lrcArray = [tmpStr componentsSeparatedByString:@"\n"];
    //数据解析并将空数据去掉
    for (NSString *lrcStr in lrcArray)
    {
        if (lrcStr.length == 0)
        {
            continue;
            //去掉空数据
        }
        //判断是歌词还是文件信息数据
        unichar c = [lrcStr characterAtIndex:1];
        //每一个单词对应的
        if (c >='0' && c <= '9')
        //如果当前字符的第二个下表对应的是数字0-9之间 说明是歌词文件
        {
            //是歌词数据
            [self getLrcData:lrcStr];
        }else
        {
            //是文件数据
            [self getInfoData:lrcStr];
        }
    }
    [_lrcArray sortUsingSelector:@selector(isTimeOlderThanAnother:)];
    //重新排序
}

//获取歌词数据
-(void)getLrcData:(NSString *)lrcStr{
    //按照]进行分割
    NSArray *arr = [lrcStr componentsSeparatedByString:@"]"];
    //解析时间，同一行歌词只能对应多个时间，最后一个元素是歌词
    for (int i=0; i<arr.count-1; i++) {
        //去电[号
        NSString *timeStr = [arr[i] substringFromIndex:1];
        //把时间字符串转化为以s为单位
        NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
        float min = [timeArr[0]floatValue];
        float sec = [timeArr[1]floatValue];
        
        //创建模型
        LRCItem *item = [[LRCItem alloc] init];
        item.time = min*60 + sec;
        
        item.lrc = [arr lastObject];
        

        [_lrcArray addObject:item];
    }
}
//获取文件数据
-(void)getInfoData:(NSString *)lrcStr
{
    NSArray *arr = [lrcStr componentsSeparatedByString:@":"];
    //获取内容长度 带]符号
    NSInteger len = [arr[1] length];
    
    if ([arr[0] isEqualToString:@"[ti"])
    {
        _title = [arr[1] substringToIndex:len-1];
    }else if ([arr[0] isEqualToString:@"[ar"])
    {
        _author = [arr[1] substringToIndex:len-1];
    }else if([arr[0] isEqualToString:@"[al"])
    {
        _albume = [arr[1] substringToIndex:len-1];
    }
}

//2.显示数据到视图上
-(void)getCurrentLRCInLRCArray:(void(^)(NSArray * _Nonnull, int))handle atTime:(float)time{
    if (!_lrcArray.count)
    {
        handle(nil,0);
    }
    //找到第一个大于时间time的歌词位置
    int index = -2;
    for (int i=0; i<_lrcArray.count; i++)
    {
        float lrcTime = [_lrcArray[i] time];
        //if数据模型的time大于传入的这个time值
        if (lrcTime > time)
        {
            index = i - 1;
            break;
        }
    }
    if (index==-1)
    {
        //第一条数据
        index = 0;
    }else if (index == -2)
    {
        //没有更大的时间了，最后一条数据
        index=(int)_lrcArray.count-1;
    }
    handle(_lrcArray,index);
}
@end
