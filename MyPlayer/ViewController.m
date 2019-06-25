//
//  ViewController.m
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import "ViewController.h"
#import <notify.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    LRCEngine *engine = [[LRCEngine alloc] initWithFile:@"薛之谦-摩天大楼"];
//    [engine getCurrentLRCInLRCArray:^(NSArray * _Nonnull lrcArray, int currectIndex) {
//        if (lrcArray) {
//            NSLog(@"%@\n==================\n%@test1",lrcArray,[lrcArray[currectIndex] lrc]);
////            NSLog(@"test2:%@",[lrcArray[45] lrc]);
//        }
//    } atTime:36.740002];
//    //以上问题待解决
//    //数据获取不到在36.740002的lrc数据

    
//    通知管理类 熄灭屏幕之后 会在通知中心显示一个简化版的播放器（不过之前的苹果手机坏了 不能真机调试）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneToBack) name:@"goBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneToForward) name:@"goForward" object:nil];
    _isBack = NO;
    //创建数据
    [self creatData];
    //创建播放模块
    [self creatPlayer];
    //创建视图模块
    [self creatView];
    //进行UI界面的刷新
    [self updateUI];
    
    // Do any additional setup after loading the view, typically from a nib.
}
//创建数据
-(void)creatData{
    _dataArray = @[@"薛之谦-摩天大楼",@"薛之谦-你还要我怎样",@"薛之谦-像风一样"];
}
//创建播放模块
-(void)creatPlayer{
    _player = [[MyMusicPlayer alloc] init];
    _player.songsArray = _dataArray;
    NSMutableArray *mulArr = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArray.count; i++) {
        //进行歌词模块的创建
        LRCEngine *engine = [[LRCEngine alloc] initWithFile:_dataArray[i]];
        [mulArr addObject:engine];
    }
    _player.lrcsArray = mulArr;
    _player.delegate = self;
}
//创建视图模块
-(void)creatView{
    //创建背景
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"BG.image"];
    
    //设置为可接收用户交互
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    
    //创建歌曲标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, bg.frame.size.width, 40)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textAlignment =NSTextAlignmentCenter;
    _titleLabel.text = _dataArray[0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [bg addSubview:_titleLabel];
    
    //创建歌曲进度条
    _progress = [[UISlider alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-70, self.view.frame.size.width-40, 5)];
    _progress.minimumTrackTintColor = [UIColor blueColor];
    _progress.maximumTrackTintColor = [UIColor redColor];
    _progress.continuous = NO;
    
    [_progress addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
//        [_progress addTarget:self action:@selector(valueChange)forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
//    [_progress addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventTouchUpInside];
//    [_progress addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventTouchUpOutside];
    [_progress addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventTouchDown];

    
    
    [bg addSubview:_progress];
    
    //创建播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _playBtn.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height-45, 40, 30);
    [_playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_playBtn];
    
    //创建下一曲按钮
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.frame.size.width/2+40,self.view.frame.size.height-45, 40, 30);
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"nextMusic"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_nextBtn];
    
    //创建上一曲按钮
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame = CGRectMake(self.view.frame.size.width/2-80,self.view.frame.size.height-45, 40, 30);
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"aboveMusic"] forState:UIControlStateNormal];
    [_lastBtn addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_lastBtn];
    
    //创建循环播放按钮
    _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _circleBtn.frame = CGRectMake(self.view.frame.size.width/2-140,self.view.frame.size.height-45, 40, 30);
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleClose"] forState:UIControlStateNormal];
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleOpen"] forState:UIControlStateSelected];
    [_circleBtn addTarget:self action:@selector(circle) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_circleBtn];
    
    //创建随机播放按钮
    _randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _randomBtn.frame = CGRectMake(self.view.frame.size.width/2+100,self.view.frame.size.height-45, 40, 30);
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"randomClose"] forState:UIControlStateNormal];
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"openRandom"] forState:UIControlStateSelected];
    [_randomBtn addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_randomBtn];
    
    //创建歌曲列表与歌词显示控件视图
    _contentView = [[MusicContentView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-150)];
    _contentView.titleDataArray = _dataArray;
//    _contentView.backgroundColor = [UIColor redColor];
    [bg addSubview:_contentView];
    
}
- (void)valueChange{
    _player.hadPlayTime = _progress.value * _player.currentSongTime;
    float updateTime = _player.hadPlayTime;
//    _progress.value = (float)_player.hadPlayTime/_player.currentSongTime;
    [self update:updateTime];
    
//    NSLog(@"hadtime%d",_player.hadPlayTime);
//    NSLog(@"_progerss.vlaue = %f",_progress.value);
//    NSLog(@"_player.hadPlayTime = %f",_player.hadPlayTime);
    
}


//进行UI界面的刷新
-(void)updateUI
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)update:(float)updateTime
{
    uint64_t locked;
    __block int token = 0;
    
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen", &token, dispatch_get_main_queue(), ^(int token) {
        
    });
    notify_get_state(token, &locked);
    //如果设备屏幕关闭，就跳过更新方法
    if (locked) {
        return;
    }
    
    _titleLabel.text = _dataArray[[_player currentIndex]];
    
    // 当前的值改变，也需要更新进度条
    // 更新进度条
    if (_player.hadPlayTime!=0) {
        //        _player.hadPlayTime = _progress.value * _player.currentSongTime;
        _progress.value = (float)_player.hadPlayTime/_player.currentSongTime;
    }
    
   
    
    //更新歌词
    LRCEngine *engine = _player.lrcsArray[_player.currentIndex];
    [engine getCurrentLRCInLRCArray:^(NSArray * _Nonnull lrcArray, int currectIndex) {
        [_contentView setCurretLRCArray:lrcArray index:currectIndex];
    } atTime:_player.hadPlayTime];
    
    //更新锁屏界面
    //如果在后台，就再更新，否则不更新
    if (!_isBack) {
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_dataArray[_player.currentIndex] forKey:MPMediaItemPropertyTitle];
    [dict setObject:@"薛之谦" forKey:MPMediaItemPropertyArtist];
    [dict setObject:@"渡" forKey:MPMediaItemPropertyAlbumTitle];
    
    UIImage *newImage = _contentView.lrcImage;
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage] forKey:MPMediaItemPropertyArtwork];
    [dict setObject:[NSNumber numberWithDouble:_player.currentSongTime] forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithDouble:_player.hadPlayTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];//音乐已过当前时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

//
-(void)phoneToBack
{
    _isBack = YES;
}
-(void)phoneToForward
{
    _isBack = NO;
}

//播放音乐
-(void)playMusic
{
    if(_player.isPlaying)
    {
        _playBtn.selected = NO;
        [_player stop];
    }else
    {
        _playBtn.selected = YES;
        [_player play];
    }
}

//下一曲
-(void)next
{
    [_player nextMusic];
}

//上一曲
-(void)last
{
    [_player lastMusic];
}

//循环播放
-(void)circle
{
    if (_player.isRunLoop)
    {
        _player.isRunLoop = NO;
        _circleBtn.selected = NO;
    }else
    {
        _player.isRunLoop = YES;
        _circleBtn.selected = YES;
    }
}

//随机播放
-(void)random
{
    if (_player.isRandom)
    {
        _player.isRandom = NO;
        _randomBtn.selected = NO;
    }else
    {
        _player.isRandom = YES;
        _randomBtn.selected = YES;
    }
}
//是否循环播放
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play{
    if (play) {
        _playBtn.selected=YES;
    }else{
        _playBtn.selected=NO;
    }
}
@end
