//
//  BeginImageContext.h
//  屏幕截图
//
//  Created by ZhangCheng on 14-4-7.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//
/*
此类用于屏幕截图
添加库：无
代码示例 为截取全屏
[BeginImageContext beginImageContext:self.view.frame View:self.view];
 2个参数 第一个参数用于截取的范围，第二个参数截取哪个view上
 
 
 */
#import <Foundation/Foundation.h>

@interface BeginImageContext : NSObject
+(UIImage*)beginImageContext:(CGRect)rect View:(UIView*)view;
@end
