//
//  CYDrawViewController.h
//  CYCultureAgents
//
//  Created by 杨旗 on 14-12-3.
//  Copyright (c) 2014年 CeYu. All rights reserved.
//

#import <UIKit/UIKit.h>


//发送图片的协议：
@protocol imageDelegate <NSObject>

@required

-(void)sendimage:(UIImage *)image;  //发送图片的协议方法

@optional

@end


@interface CYDrawViewController : UIViewController

@property(assign,nonatomic)id<imageDelegate>delegate;   //图片的代理字段

@end
