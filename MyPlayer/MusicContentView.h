//
//  MusicContentView.h
//  MyPlayer
//
//  Created by Admin on 2019/1/8.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMusicPlayer.h"
#import "LRCItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface MusicContentView : UIView <UITableViewDataSource,UITableViewDelegate>

//歌曲列表数据源数组
@property (nonatomic ,strong) NSArray *titleDataArray;
//这个方法设置当前页面显示的歌词，对应歌曲播放的相应时间
-(void)setCurretLRCArray:(NSArray *)array index:(int)index;
//播放器引擎对象的引用
@property (nonatomic, strong)MyMusicPlayer *play;
//锁屏界面要显示的图片
@property (nonatomic, readonly)UIImage *lrcImage;

@end

NS_ASSUME_NONNULL_END
