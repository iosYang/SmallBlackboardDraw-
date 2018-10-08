//
//  BeginImageContext.m
//  屏幕截图
//
//  Created by ZhangCheng on 14-4-7.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "BeginImageContext.h"

@implementation BeginImageContext
+(UIImage*)beginImageContext:(CGRect)rect View:(UIView*)view
{
    
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
   
    //从全屏中截取指定的范围
   
    UIImage *image=[[UIImage alloc]initWithCGImage:viewImage.CGImage];
   // NSLog(@"---%d",image.retainCount);

    CGImageRef imageRefRect =CGImageCreateWithImageInRect(image.CGImage, rect);
  //  NSLog(@"^^^%d",image.retainCount);
    [image release];
   
    //[image release];
    
   // UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
   UIImage *sendImage = [UIImage imageWithCGImage:imageRefRect];
    
    return sendImage ;
//    /******截取图片保存的位置，如果想要保存，请把return向后移动*********/
//    
//    NSData*data=UIImagePNGRepresentation(viewImage);
//    NSString*path=[NSHomeDirectory() stringByAppendingString:@"/documents/1.png"];
//    [data writeToFile:path atomically:YES];
//    
//    NSLog(@"%@",path);
//    
//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
//    CGImageRelease(imageRefRect);
    /***************/

}
@end
