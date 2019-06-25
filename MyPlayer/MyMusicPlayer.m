//
//  MyMusicPlayer.m
//  MyPlayer
//
//  Created by Admin on 2019/1/8.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import "MyMusicPlayer.h"
#import "AppDelegate.h"
@implementation MyMusicPlayer
{
    //player用于处理音频的播放
    AVAudioPlayer *_player;
    //timer属性用于进行播放时间的更新
    NSTimer *_timer;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //创建一个定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.play = self;
        //以上方法初始化了定时器，并将当前对象与程序的AppDelegate对象进行了关联
    }
    return self;
}
//实现刷新方法
-(void)update
{
    if (_player) {
        _hadPlayTime = _player.currentTime;
        //将当前播放器的时间赋值给_hadPlayTime这个属性
    }
}

//进行继续播放与暂停播放的切换
-(void)playOrStop
{
    //先判断是否在播放
    if (self.isPlaying)
    {
        //已经在播放，则进行暂停播放操作
        [self stop];
    }else
    {
        //没有播放
        [self play];
    }
}
//开始播放
-(void)play
{
    //判断AVAudioPlayer对象是否存在
    if (_player!=nil)
    {
        [_player play];
        _isPlaying = YES;
        return;
    }else
    {
        //从歌曲数组中读取第一个元素
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:0] ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        _currentIndex = 0;
        _currentSongTime = _player.duration;//该音频时长属性赋值给当前音频文件的时长
    }
}
//暂停播放
-(void)stop
{
    if (_player.isPlaying) {
        [_player stop];
        _isPlaying = NO;
    }

}
//停止
-(void)end
{
    [_player stop];
    _isPlaying = NO;
    _player = nil;
}
//播放指定的音频文件
-(void)playAtIndex:(int)index isPlay:(BOOL)play{
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:index] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    if (play)
    {
        [_player play];
        _isPlaying = YES;
    }
    _currentIndex = index;
    _currentSongTime = _player.duration;
    //将当前音频的时长给_currentSongTime
}

//下一曲
-(void)nextMusic
{
    BOOL play = _player.isPlaying;
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    
    //是否是最后一曲
    if (_currentIndex < self.songsArray.count - 1)
    {
        _currentIndex++;
    }else
    {
        _currentIndex = 0;
    }
    //是否随机播放
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random()%max;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _currentSongTime = _player.duration;
    _player.delegate = self;
    if (play) {
        [_player play];
        _isPlaying = YES;
    }
    
}
//上一曲
-(void)lastMusic
{
    BOOL play = _player.isPlaying;
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    
    //是否是最后一曲
    if (_currentIndex > 0)
    {
        //如果当前下标大于0播放上一曲
        _currentIndex--;
    }else
    {
        //下标不大于0 则播放最后一曲
        _currentIndex = (int)_songsArray.count-1;
    }
    //是否随机播放 ?提问 这个随机播放是否可以放在前面
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random()%max;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _currentSongTime = _player.duration;
    _player.delegate = self;
    if (play) {
        [_player play];
        _isPlaying = YES;
    }
}

#pragma mark AVAudioPlayerDelegate --
//一个播放结束之后调用的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _player = nil;
    _isPlaying =NO;
    //是否随机播放
    if (_isRandom)
    {
        unsigned long max = self.songsArray.count;
        int songIndex = arc4random()%max;
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:songIndex] ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        
        //是否
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        _currentIndex = songIndex;
        _currentSongTime = _player.duration;
        return;
    }
    //是否是最后一首
    if (_currentIndex < self.songsArray.count - 1)
    {
        //不是最后一首
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:++_currentIndex] ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _currentSongTime = _player.duration;
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
    }else if(_currentIndex == self.songsArray.count-1)
    {
        //是最后一首
        //是否循环到第一首歌播放
        if(_isRunLoop)
        {
            _currentIndex = 0;
            NSString *path = [[NSBundle mainBundle] pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
            NSURL *url = [NSURL fileURLWithPath:path];
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            _player.delegate = self;
            _currentSongTime = _player.duration;
            [player play];
            _isPlaying = YES;
            [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        }else
        {
            [self.delegate musicPlayEndAndWillContinuePlaying:NO];
        }
    }
}
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play{
    
}

@end
