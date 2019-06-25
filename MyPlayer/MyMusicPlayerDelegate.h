//
//  MyMusicPlayerDelegate.h
//  MyPlayer
//
//  Created by Admin on 2019/1/8.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyMusicPlayerDelegate <NSObject>

//音频播放完毕之后是否自动播放下一个音频
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play;

@end

NS_ASSUME_NONNULL_END
