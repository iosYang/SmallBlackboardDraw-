//
//  CYShowViewController.m
//  SmallBlackboardDraw
//
//  Created by CeYu on 14-12-4.
//  Copyright (c) 2014年 CeYu. All rights reserved.
//

#import "CYShowViewController.h"

@interface CYShowViewController ()

@property (nonatomic,retain) UIImage * showImage;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@end

@implementation CYShowViewController
{
    BOOL hasSavePicOrNOtBool;//是否图片已经存储
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark---自定义初始化方法
-(id)initWithShowImage:(UIImage *)showImage
{
    if (self =[super init]) {
        _showImage=showImage;
        hasSavePicOrNOtBool=NO;
    }
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //屏幕与控件适配
    [self screenAdapt];
    
    //设置导航条
    [self setNaviBar];
    
    //SET IMAGE
    [self setShowImage];
}

#pragma mark---屏幕与控件适配
-(void)screenAdapt
{
    //屏幕大小与内容视图大小的适配
    if (IOS7_OR_LATER) {
        self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _contentView.frame=CGRectMake(0, NavBarHeight+StatueBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-StatueBarHeight);
    }else{
        self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatueBarHeight);
        _contentView.frame=CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-StatueBarHeight);
    }

}

#pragma mark---设置导航条
-(void)setNaviBar
{
    //隐藏系统导航条
    self.navigationController.navigationBarHidden=YES;
    
    
    //显示自定义导航条
    if (IOS7_OR_LATER) {
        UIView *naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight+StatueBarHeight)];
        naviView.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:naviView];
        [naviView release];
        
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 40, 24)];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:backBtn];
        [backBtn release];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40+10, 30, ScreenWidth-(10+40)*2, 24)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"查看绘图";
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-40, 30, 40, 24)];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(savePic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveBtn];
        [saveBtn release];
        
    }else{
        UIView *naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
        naviView.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:naviView];
        [naviView release];
        
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 24)];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:backBtn];
        [backBtn release];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40+10, 10, ScreenWidth-(10+40)*2, 24)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"查看绘图";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:20];
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-40, 10, 40, 24)];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(savePic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveBtn];
        [saveBtn release];
    }

}

#pragma mark---setShowImage
-(void)setShowImage
{
    _showImageView.image=_showImage;
}

#pragma mark---返回事件
-(void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark---保存图片到相册中
-(void)savePic:(UIButton *)button
{
    if (!hasSavePicOrNOtBool) {
        
        [self saveImageToPhotos:_showImage];
        hasSavePicOrNOtBool=YES;

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"正在进行保存操作或图片之前已经保存过了"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark---存储图片的方法
- (void)saveImageToPhotos:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
#pragma mark---指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        hasSavePicOrNOtBool=NO;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark---释放
-(void)dealloc
{
    _showImage=nil;
    _showImageView.image=nil;
    _contentView=nil;
    _showImageView=nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
