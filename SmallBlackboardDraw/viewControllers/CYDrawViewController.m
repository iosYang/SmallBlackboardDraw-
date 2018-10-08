//
//  CYDrawViewController.m
//  CYCultureAgents
//
//  Created by 杨旗 on 14-12-3.
//  Copyright (c) 2014年 CeYu. All rights reserved.
//

#import "CYDrawViewController.h"

#import "BeginImageContext.h"   //截图类
#import "PIDrawerView.h"        //绘图类


//定义 颜色按钮 与 颜色视图 的弧度
#define COLOR_BUTTION_SMALL_CORNER_RADIUS   10
#define COLOR_BUTTION_BIG_CORNER_RADIUS     17
#define COLOR_VIEW_BIG_CORNER_RADIUS        19

//定义三种粗细的笔触值
#define SMALL_LINE_WIDTH_CAP_VALUE          4
#define MEDIUN_LINE_WIDTH_CAP_VALUE         14
#define BIG_LINE_WIDTH_CAP_VALUE            24

@interface CYDrawViewController ()

//内容视图
@property (strong, nonatomic) IBOutlet UIView *contetView;

//涂鸦区域区域
@property (strong, nonatomic) IBOutlet PIDrawerView *drawerView;

//三种操作的按钮
@property (strong, nonatomic) IBOutlet UIButton *canclebtn;
@property (strong, nonatomic) IBOutlet UIButton *revcationBtn;
@property (strong, nonatomic) IBOutlet UIButton *drawbtn;

//五种操作的点击事件
- (IBAction)cancleBtnClick:(id)sender;
- (IBAction)revcationBtnClick:(id)sender;
- (IBAction)drawBtnClick:(id)sender;

//五种颜色的视图
@property (strong, nonatomic) IBOutlet UIView *redView;
@property (strong, nonatomic) IBOutlet UIView *yellowView;
@property (strong, nonatomic) IBOutlet UIView *blueView;
@property (strong, nonatomic) IBOutlet UIView *greenView;
@property (strong, nonatomic) IBOutlet UIView *whiteView;

//五种颜色相关的按钮
@property (strong, nonatomic) IBOutlet UIButton *redBtn;
@property (strong, nonatomic) IBOutlet UIButton *yellowBtn;
@property (strong, nonatomic) IBOutlet UIButton *blueBtn;
@property (strong, nonatomic) IBOutlet UIButton *greenBtn;
@property (strong, nonatomic) IBOutlet UIButton *whiteBtn;

//五种颜色选择点击事件
- (IBAction)redBtnClick:(id)sender;
- (IBAction)yellowBtnClick:(id)sender;
- (IBAction)blueBtnClick:(id)sender;
- (IBAction)greenBtnClick:(id)sender;
- (IBAction)whiteBtnClick:(id)sender;

//更换笔触的视图
@property (strong, nonatomic) IBOutlet UIView *LineCapWidthView;

//三种不同粗细的笔触
- (IBAction)smallWidthLineTap:(id)sender;
- (IBAction)mediumWidthLineTap:(id)sender;
- (IBAction)bigWidthLineTap:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *operatorView;
@property (strong, nonatomic) IBOutlet UIView *colorSetView;

//当前被选择的颜色
@property (strong,nonatomic)UIColor *selectColor;

@end

@implementation CYDrawViewController{
    
    //判断当前那一种颜色处于变大状态
    BOOL redBigBool;
    BOOL yellowBigBool;
    BOOL blueBigBool;
    BOOL greenBigBool;
    BOOL whiteBigBool;
    
    //颜色按钮控件的变化前的frame
    CGRect redOldBtnFrame;
    CGRect yellowOldBtnFrame;
    CGRect blueOldBtnFrame;
    CGRect greenOldBtnFrame;
    CGRect whiteOldBtnFrame;

    //颜色按钮控件变化后的frame
    CGRect redNewBtnFrame;
    CGRect yellowNewBtnFrame;
    CGRect blueNewBtnFrame;
    CGRect greenNewBtnFrame;
    CGRect whiteNewBtnFrame;
    
    //笔触修改的视图的两种状态的frame
    CGRect LineCapWidthViewShowFrame;
    CGRect LineCapWidthViewHiddenFrame;
    
    //当前笔触修改的视图是否处于显示状态
    BOOL LineCapWidthViewShowOrNotBool;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark---视图将要出现时
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //屏幕适配
    [self screenAdapt];
    
}

#pragma mark---屏幕适配
-(void)screenAdapt
{
    //屏幕大小与内容视图大小的适配
    if (IOS7_OR_LATER) {
        self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _contetView.frame=CGRectMake(0, NavBarHeight+StatueBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-StatueBarHeight);
    }else{
        self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatueBarHeight);
        _contetView.frame=CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-StatueBarHeight);
    }
    
 
    if (ScreenHeight==480) {
        _operatorView.frame=CGRectMake(_operatorView.frame.origin.x, _operatorView.frame.origin.y-10,_operatorView.frame.size.width, _operatorView.frame.size.height);
        
        _colorSetView.frame=CGRectMake(_colorSetView.frame.origin.x, _colorSetView.frame.origin.y+20, _colorSetView.frame.size.width, _colorSetView.frame.size.height);
    }
}

#pragma mark---视图装载时
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set NaviBar
    [self setNaviBar];
    
    //设置各个控件初始化UI；
    [self setWidgeView];
    [self getColorViewFrame];
    
    //默认是黑色点击；
    [self redBtnClick:nil];

    //默认的笔触宽度
    [self smallWidthLineTap:nil];
    
    //笔触视图初始化
    [self setLineCapWidthView];
    
}

#pragma mark---设置导航条的宽度
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
        titleLabel.text=@"小黑板";
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *finishBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-40, 30, 40, 24)];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(drawFinished:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:finishBtn];
        [finishBtn release];
        
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
        titleLabel.text=@"小黑板";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:20];
        [self.view addSubview:titleLabel];
        [titleLabel release];

        UIButton *finishBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-40, 10, 40, 24)];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(drawFinished:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:finishBtn];
        [finishBtn release];
    }
}

#pragma mark---设置返回的事件
-(void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark---完成绘画操作
-(void)drawFinished:(UIButton *)button
{
    
    if ([_delegate respondsToSelector:@selector(sendimage:)]) {
        UIImage *image = [BeginImageContext beginImageContext:_drawerView.frame View:_contetView];
         [self.delegate sendimage:image];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark---各个控件UI基本设置
-(void) setWidgeView{

    //设置按钮的属性
    _redBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _redBtn.layer.masksToBounds = YES;
    
    _yellowBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _yellowBtn.layer.masksToBounds = YES;
    
    _blueBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _blueBtn.layer.masksToBounds = YES;
    
    _greenBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _greenBtn.layer.masksToBounds = YES;
    
    _whiteBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _whiteBtn.layer.masksToBounds = YES;

    //设置颜色的阴影设置当前状态
    _redView.layer.masksToBounds=YES;
    _yellowView.layer.masksToBounds=YES;
    _blueView.layer.masksToBounds=YES;
    _greenView.layer.masksToBounds=YES;
    _whiteView.layer.masksToBounds=YES;
    
    _redView.hidden = YES;
    _yellowView.hidden=YES;
    _blueView.hidden = YES;
    _greenView.hidden=YES;
    _whiteView.hidden = YES;
    
    //颜色按钮的大小布尔值
    redBigBool = NO;
    yellowBigBool=NO;
    blueBigBool = NO;
    greenBigBool = NO;
    whiteBigBool = NO;

}

#pragma mark---获取控件的视图
-(void)getColorViewFrame
{
    //颜色按钮控件的变化前的frame记录
    redOldBtnFrame      =   _redBtn.frame;;
    yellowOldBtnFrame   =   _yellowBtn.frame;
    blueOldBtnFrame     =   _blueBtn.frame;
    greenOldBtnFrame    =   _greenBtn.frame;
    whiteOldBtnFrame    =   _whiteBtn.frame;
    
    //颜色按钮控件变化后的frame记录
    redNewBtnFrame      =   CGRectMake(_redBtn.frame.origin.x-8,_redBtn.frame.origin.y-8, _redBtn.frame.size.width +16, _redBtn.frame.size.height+16);
    yellowNewBtnFrame   =   CGRectMake(_yellowBtn.frame.origin.x-8, _yellowBtn.frame.origin.y-8, _yellowBtn.frame.size.width +16, _yellowBtn.frame.size.height+16);;
    blueNewBtnFrame     =   CGRectMake(_blueBtn.frame.origin.x-8, _blueBtn.frame.origin.y-8, _blueBtn.frame.size.width +16, _blueBtn.frame.size.height+16);
    greenNewBtnFrame    =   CGRectMake(_greenBtn.frame.origin.x-8, _greenBtn.frame.origin.y-8, _greenBtn.frame.size.width +16, _greenBtn.frame.size.height+16);
    whiteNewBtnFrame    =   CGRectMake(_whiteBtn.frame.origin.x-8, _whiteBtn.frame.origin.y-8, _whiteBtn.frame.size.width +16, _whiteBtn.frame.size.height+16);
}

#pragma mark---设置笔触修改视图的初始化状态
-(void)setLineCapWidthView
{
    //笔触修改的视图的两种状态的frame
    LineCapWidthViewShowFrame=_LineCapWidthView.frame;
    _LineCapWidthView.frame=CGRectMake(-_LineCapWidthView.frame.size.width, _LineCapWidthView.frame.origin.y, _LineCapWidthView.frame.size.width, _LineCapWidthView.frame.size.height);
    LineCapWidthViewHiddenFrame=_LineCapWidthView.frame;
    //当前笔触修改的视图是否处于显示状态
   LineCapWidthViewShowOrNotBool=NO;
}

#pragma mark---小、中、大 三种笔触的tap事件
- (IBAction)smallWidthLineTap:(id)sender {
    [_drawerView setLineCapWitdh:SMALL_LINE_WIDTH_CAP_VALUE];
}
- (IBAction)mediumWidthLineTap:(id)sender {
    [_drawerView setLineCapWitdh:MEDIUN_LINE_WIDTH_CAP_VALUE];
}
- (IBAction)bigWidthLineTap:(id)sender {
    [_drawerView setLineCapWitdh:BIG_LINE_WIDTH_CAP_VALUE];
}

#pragma mark---取消事件
- (IBAction)cancleBtnClick:(id)sender {
    [self.drawerView.ImageArray removeAllObjects];
    self.drawerView.viewImage = [self.drawerView.ImageArray lastObject];
    [self.drawerView getImage];
}

#pragma mark---撤销事件
- (IBAction)revcationBtnClick:(id)sender
{
    [self.drawerView.ImageArray removeLastObject];
    self.drawerView.viewImage = [self.drawerView.ImageArray lastObject];
    [self.drawerView getImage];
}

#pragma mark---笔触事件
- (IBAction)drawBtnClick:(id)sender {
    
    _Block_H_ CYDrawViewController *blockSelf=self;
    
    if (LineCapWidthViewShowOrNotBool) {
        [UIView animateWithDuration:0.5 animations:^{
            blockSelf.LineCapWidthView.frame=LineCapWidthViewHiddenFrame;
        }];
        LineCapWidthViewShowOrNotBool=NO;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            blockSelf.LineCapWidthView.frame=LineCapWidthViewShowFrame;
        }];
        LineCapWidthViewShowOrNotBool=YES;
    }
}

#pragma mark---选择红色的事件
- (IBAction)redBtnClick:(id)sender {
    self.selectColor = [UIColor redColor];
    [self.drawerView setSelectedColor:_selectColor];

    if (redBigBool == NO) {
        
        _redBtn.frame = redNewBtnFrame;
        _redView.hidden = NO;
        redBigBool = YES;
        
        _redBtn.layer.cornerRadius = COLOR_BUTTION_BIG_CORNER_RADIUS;
        _redView.layer.cornerRadius =COLOR_VIEW_BIG_CORNER_RADIUS;
    }
    
    _yellowBtn.frame=yellowOldBtnFrame;
    _blueBtn.frame =blueOldBtnFrame;
    _greenBtn.frame=greenOldBtnFrame;
    _whiteBtn.frame =whiteOldBtnFrame;
    
    _yellowBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _blueBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _greenBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _whiteBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    
    _yellowView.hidden=YES;
    _blueView.hidden=YES;
    _greenView.hidden=YES;
    _whiteView.hidden = YES;
    
    yellowBigBool=NO;
    blueBigBool=NO;
    greenBigBool=NO;
    whiteBigBool = NO;
}

#pragma mark---选择黄色的事件
- (IBAction)yellowBtnClick:(id)sender {
    self.selectColor = [UIColor yellowColor];
    [self.drawerView setSelectedColor:_selectColor];
    
    if (yellowBigBool == NO) {
        
        _yellowBtn.frame = yellowNewBtnFrame;
        _yellowView.hidden = NO;
        yellowBigBool = YES;
        
        _yellowBtn.layer.cornerRadius = COLOR_BUTTION_BIG_CORNER_RADIUS;
        _yellowView.layer.cornerRadius = COLOR_VIEW_BIG_CORNER_RADIUS;
    }
    
    _redBtn.frame=redOldBtnFrame;
    _blueBtn.frame =blueOldBtnFrame;
    _greenBtn.frame=greenOldBtnFrame;
    _whiteBtn.frame =whiteOldBtnFrame;
    
    _redBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _blueBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _greenBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _whiteBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    
    _redView.hidden=YES;
    _blueView.hidden=YES;
    _greenView.hidden=YES;
    _whiteView.hidden = YES;
    
    redBigBool=NO;
    blueBigBool=NO;
    greenBigBool=NO;
    whiteBigBool =NO;
}

#pragma mark---选择蓝色的事件
- (IBAction)blueBtnClick:(id)sender {
    self.selectColor = [UIColor blueColor];
    [self.drawerView setSelectedColor:_selectColor];
    
    if (blueBigBool == NO) {
        
        _blueBtn.frame =blueNewBtnFrame;
        _blueView.hidden = NO;
        blueBigBool = YES;
        
        _blueBtn.layer.cornerRadius = COLOR_BUTTION_BIG_CORNER_RADIUS;
        _blueView.layer.cornerRadius = COLOR_VIEW_BIG_CORNER_RADIUS;
    }
    
    _redBtn.frame=redOldBtnFrame;
    _yellowBtn.frame =yellowOldBtnFrame;
    _greenBtn.frame=greenOldBtnFrame;
    _whiteBtn.frame =whiteOldBtnFrame;
    
    _redBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _yellowBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _greenBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _whiteBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    
    _redView.hidden=YES;
    _yellowView.hidden=YES;
    _greenView.hidden=YES;
    _whiteView.hidden = YES;
    
    redBigBool=NO;
    yellowBigBool=NO;
    greenBigBool=NO;
    whiteBigBool = NO;
}

#pragma mark---选择绿色的事件
- (IBAction)greenBtnClick:(id)sender {
    self.selectColor = [UIColor greenColor];
    [self.drawerView setSelectedColor:_selectColor];
    
    if (greenBigBool == NO) {
        
        _greenBtn.frame =greenNewBtnFrame;
        _greenView.hidden = NO;
        greenBigBool = YES;
        
        _greenBtn.layer.cornerRadius = COLOR_BUTTION_BIG_CORNER_RADIUS;
        _greenView.layer.cornerRadius =COLOR_VIEW_BIG_CORNER_RADIUS;
    }
    
    _redBtn.frame=redOldBtnFrame;
    _yellowBtn.frame =yellowOldBtnFrame;
    _blueBtn.frame=blueOldBtnFrame;
    _whiteBtn.frame =whiteOldBtnFrame;
    
    _redBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _yellowBtn.layer.cornerRadius = COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _blueBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _whiteBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    
    _redView.hidden=YES;
    _yellowView.hidden=YES;
    _blueView.hidden=YES;
    _whiteView.hidden = YES;
    
    redBigBool=NO;
    yellowBigBool=NO;
    blueBigBool=NO;
    whiteBigBool = NO;
}

#pragma mark---选择白色的事件
- (IBAction)whiteBtnClick:(id)sender
{
    self.selectColor = [UIColor whiteColor];
    [self.drawerView setSelectedColor:_selectColor];

    if (whiteBigBool == NO) {
        
        _whiteBtn.frame = whiteNewBtnFrame;
        _whiteView.hidden = NO;
        whiteBigBool = YES;

        _whiteBtn.layer.cornerRadius = COLOR_BUTTION_BIG_CORNER_RADIUS;
        _whiteView.layer.cornerRadius =COLOR_VIEW_BIG_CORNER_RADIUS;
        
    }

    _redBtn.frame =redOldBtnFrame;
    _yellowBtn.frame=yellowOldBtnFrame;
    _blueBtn.frame =blueOldBtnFrame;
    _greenBtn.frame=greenOldBtnFrame;

    _redBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _yellowBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _blueBtn.layer.cornerRadius =COLOR_BUTTION_SMALL_CORNER_RADIUS;
    _greenBtn.layer.cornerRadius=COLOR_BUTTION_SMALL_CORNER_RADIUS;

    _redView.hidden = YES;
    _yellowView.hidden=YES;
    _blueView.hidden=YES;
    _greenView.hidden=YES;

    redBigBool = NO;
    yellowBigBool=NO;
    blueBigBool=NO;
    greenBigBool=NO;

}

#pragma mark---释放
-(void)dealloc
{
    //释放控件
    //五种颜色的视图
    [_redView release];
    [_yellowView release];
    [_blueView release];
    [_greenView release];
    [_whiteView release];
    
    //五种颜色相关的按钮
    [_redBtn release];
    [_yellowBtn release];
    [_blueBtn release];
    [_greenBtn release];
    [_whiteBtn release];
    
    //三种操作的按钮
    [_canclebtn release];
    [_revcationBtn release];
    [_drawbtn release];
    
    //涂鸦区域区域
    [_drawerView release];
    
    //内容视图
    [_contetView release];
    
    //父类调用释放
    [super dealloc];
}

#pragma mark---街道内存警告时的处理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
