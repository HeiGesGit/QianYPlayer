//
//  AppDelegate.h
//  MyPlayer
//
//  Created by Admin on 2019/1/5.
//  Copyright © 2019 itheima.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyMusicPlayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) MyMusicPlayer *play;
@property (strong, nonatomic) UIWindow *window;


@end

