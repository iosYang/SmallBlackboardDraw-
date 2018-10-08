//
//  CYMainViewController.m
//  SmallBlackboardDraw
//
//  Created by CeYu on 14-12-4.
//  Copyright (c) 2014年 CeYu. All rights reserved.
//

#import "CYMainViewController.h"

#import "CYDrawViewController.h"
#import "CYShowViewController.h"

@interface CYMainViewController ()<imageDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *showImage; //展示接受到到图片的小图

@end

@implementation CYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark---绘图
- (IBAction)drawImage:(id)sender {
    CYDrawViewController *drawVC=[[CYDrawViewController alloc]init];
    drawVC.delegate=self;
    _showImage.image=nil;
    [self.navigationController pushViewController:drawVC animated:YES];
    [drawVC release];
}

#pragma mark---查看
- (IBAction)showImage:(id)sender {
    
    if (_showImage.image) {
        CYShowViewController *showVC=[[CYShowViewController alloc]initWithShowImage:_showImage.image];
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
}

#pragma mark--实现imagedelegate的协议方法
-(void)sendimage:(UIImage *)image
{
    _showImage.image=image;
}

#pragma mark---释放
-(void)dealloc
{
    _showImage=nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
