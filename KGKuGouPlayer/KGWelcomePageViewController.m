//
//  KGWelcomePageViewController.m
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import "KGWelcomePageViewController.h"
#import "KGHomePageViewController.h"
#define kStartButtonCenterYRatio 470.f/667.f
#define kPageControlCenterYRatio 607.f/667.f
@interface KGWelcomePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation KGWelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //scrollview填充屏幕
     _scrollview.frame=[UIScreen mainScreen].bounds;
    //让pageControl处于屏幕的637.f/667.f比例的位置
    _pageControl.center=CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*kPageControlCenterYRatio);
   

    //设置scrollView 包括显示的图片 以及contentSize等
    [self setupScrollview];
    //设置 pageControl的数量
     _pageControl.numberOfPages=5;
}
#pragma mark 设置scrollView 包括显示的图片 以及contentSize等等
-(void)setupScrollview{//函数按功能封装
    for (int i=0; i<5; i++) {
        UIImageView*imageview=[[UIImageView alloc]init];
        NSString *imageName=[NSString stringWithFormat:@"introduction_%i",i+1];
        
        imageview.image=[UIImage imageNamed:imageName];
        imageview.frame=CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //添加开启音乐之旅按钮
        if (i==4) {
            [self addStarButton:imageview];
        }
      
        [_scrollview addSubview:imageview];
    }
    _scrollview.contentSize=CGSizeMake(5*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _scrollview.pagingEnabled=YES;
   
    _scrollview.bounces =NO;
    
}
#pragma mark 添加开启音乐之旅按钮
-(void)addStarButton:(UIImageView*)imageview{
    imageview.userInteractionEnabled=YES;//我们把button点击事件放在了第5张图片上，它的父控件（UIImageView）不接受点击事件，所以把父控件置换成接受点击事件即可
    UIButton *startbutton=[[UIButton alloc]initWithFrame:CGRectMake(100, 456, 122, 32)];
    startbutton.center=CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*kStartButtonCenterYRatio);
    [imageview addSubview:startbutton];
    [startbutton setImage:[UIImage imageNamed:@"introduction_enter_nomal"] forState:UIControlStateNormal];
    [startbutton setImage:[UIImage imageNamed:@"introduction_enter_press"] forState:UIControlStateHighlighted];
    
    [startbutton addTarget:self action:@selector(startMusicTrip:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 开启音乐之旅
-(void)startMusicTrip:(UIButton*)sender{
    //直接将主页设置为window的rootViewController 这样就不会再回到欢迎页
    UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];//首先找到storyboard
 KGHomePageViewController*homeVC=   [storyboard instantiateViewControllerWithIdentifier:@"homePage"];//再从story转到下个页面
    [UIApplication sharedApplication].keyWindow.rootViewController=homeVC;//将根控制器设置为本地音乐 下次启动就不再显示欢迎页面
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger number=(NSUInteger)_scrollview.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    _pageControl.currentPage=number;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
