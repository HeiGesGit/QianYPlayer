//
//  ViewController.h
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRCEngine.h"
#import "MyMusicPlayer.h"
#import "MusicContentView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController

{
    MyMusicPlayer *_player;
    //内容视图
    MusicContentView *_contentView;
    //标题标签
    UILabel *_titleLabel;
    //进度条
    UISlider *_progress;
    //播放按钮
    UIButton *_playBtn;
    //下一曲按钮
    UIButton *_nextBtn;
    //上一曲按钮
    UIButton *_lastBtn;
    //循环播放按钮
    UIButton *_circleBtn;
    //随机播放按钮
    UIButton *_randomBtn;
    //存放歌曲名
    NSMutableArray *_dataArray;
    NSTimer *_timer;
    BOOL _isBack;
}

@end

