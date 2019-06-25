//
//  MyMusicPlayer.h
//  MyPlayer
//
//  Created by Admin on 2019/1/8.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MyMusicPlayerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyMusicPlayer : NSObject<AVAudioPlayerDelegate>

//歌曲名数组
@property (nonatomic, strong) NSArray *songsArray;
//对应歌曲的歌词名数组
@property (nonatomic, strong) NSArray *lrcsArray;
//是否循环播放
@property (nonatomic, assign) BOOL isRunLoop;
//是否随机播放
@property (nonatomic, assign) BOOL isPlaying;
//音频播放器是否正在播放音频
@property (nonatomic, assign) BOOL isRandom;
//代理对象
@property (nonatomic, weak) id <MyMusicPlayerDelegate>delegate;
//获取当前播放的是第几个音频
@property (nonatomic, assign) int currentIndex;
//当前播放的音频文件的时长
@property (nonatomic, assign) int currentSongTime;
//当前播放的音频文件已播放的时长
@property (nonatomic, assign) int hadPlayTime;

//开始播放
-(void)play;
//暂停播放
-(void)stop;
//进行继续播放与暂停播放的切换
-(void)playOrStop;
//上一曲
-(void)lastMusic;
//下一曲
-(void)nextMusic;
//停止播放
-(void)end;
//播放指定的音频文件
-(void)playAtIndex:(int)index isPlay:(BOOL)play;

@end

NS_ASSUME_NONNULL_END
