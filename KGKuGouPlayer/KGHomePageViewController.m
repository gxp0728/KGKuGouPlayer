//
//  KGHomePageViewController.m
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import "KGHomePageViewController.h"
#import "KGHomePageMusicTableViewCell.h"
typedef enum {
    eMyMusic=0,
    eNetMusic,
    eMoreFounction
}eMusicSel;//用枚举来区分三个不同的选项 自定义enum类型

@interface KGHomePageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *icon;
- (IBAction)logon:(UIButton *)sender;
- (IBAction)signin:(UIButton *)sender;
- (IBAction)switchclick:(UIButton *)sender;
- (IBAction)myMusic:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)netMusic:(UIButton *)sender;
- (IBAction)moreFunction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *myMusicbtn;
@property (weak, nonatomic) IBOutlet UIButton *netMusicbtn;
@property (weak, nonatomic) IBOutlet UIButton *morebtn;
//@property(weak,nonatomic)UITableViewCell*curseselected;
@property(assign,nonatomic)NSInteger curselectedrow;
@property(strong,nonatomic)NSMutableArray *cellStatus;
@property(strong,nonatomic)NSArray *cellContents;
//用枚举来区分三个不同的选项
@property(assign,nonatomic)eMusicSel musicSel;
@end

@implementation KGHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor=[UIColor clearColor];//设置背景色为透明
    self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];//设置tableFooterView为空，则没有文字的cell下边就不会出现分割线
    //默认选中的是我的音乐
    [self myMusic:_myMusicbtn];
    // Do any additional setup after loading the view.
}


-(NSMutableArray *)cellStatus{
    if (_cellStatus==nil) {
      _cellStatus=[NSMutableArray array];
        

     NSString*fileName=@"MyMusicSelList.plist";
        switch (_musicSel) {//根据选项的不一样来加载不同的模型
            case eMyMusic:
            {
                fileName=@"MyMusicSelList.plist";
            }
                break;
            case eMoreFounction:{
                fileName=@"MoreList.plist";
            }
                break;
            case eNetMusic:{
                fileName=@"webMusicList.plist";
            }
                break;
            default:
                break;
        }
        _cellContents=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];

        for (int i=0; i<_cellContents.count; i++) {
            NSDictionary*dict=@{@"selected":@0};
            KGMusicCellStatus*status=[KGMusicCellStatus musicCellStatusWithDict:dict];
            [_cellStatus addObject:status];//现在只是往里面加 没有移除，所以有些问题
        }
        
    }
    return _cellStatus;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //通过MVC模型去更新cell才会完全解决内存重复利用问题！！
    KGHomePageMusicTableViewCell*cell=[KGHomePageMusicTableViewCell homePageMusicTableViewCellWithTableView:tableView];
   
    cell.status=self.cellStatus[indexPath.row];
    cell.textLabel.text=_cellContents[indexPath.row];//注意先后顺序，先进行懒加载再进行数据更新
    if (_cellContents!=nil) {
        cell.textLabel.text=_cellContents[indexPath.row];
    }
    return cell;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellStatus.count ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_curseselected!=nil) {
//        _curseselected.textLabel.textColor=[UIColor whiteColor];
//    }
//    UITableViewCell*selectedcell=[tableView cellForRowAtIndexPath:indexPath];
//    selectedcell.textLabel.textColor=[UIColor orangeColor];
//    _curseselected=selectedcell;
    if (_curselectedrow>=0) {
        KGMusicCellStatus*oldstatus=self.cellStatus[_curselectedrow];
        oldstatus.selected=NO;
    }
    KGMusicCellStatus*status=self.cellStatus[indexPath.row];
    status.selected=YES;
    _curselectedrow=indexPath.row;
    [self.tableview reloadData];
    [self performSegueWithIdentifier:@"toLocalMusic" sender:nil];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    KGMusicCellStatus*status=self.cellStatus[indexPath.row];
    status.selected=NO; //再不被点击的时候 状态设置成no；
    [self.tableview reloadData];//更新完模型 记得刷新tableview

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
#pragma mark 登录
- (IBAction)logon:(UIButton *)sender {
}
#pragma mark 注册
- (IBAction)signin:(UIButton *)sender {
}
#pragma mark 按钮切换
- (IBAction)switchclick:(UIButton *)sender {
    sender.selected=!sender.selected;
}
#pragma mark 我的音乐
- (IBAction)myMusic:(UIButton *)sender {
    sender.selected=YES;
    _netMusicbtn.selected=NO;
    _morebtn.selected=NO;
    _musicSel=eMyMusic;//点击了哪个按钮，用这个枚举变量标记你选择的哪一个选
    //在刷新之前，把懒加载置成nil才能加载
    _cellStatus=nil;
    _curselectedrow=-1;//每次切换置成－1
    //点击之后应该刷新一下tableview
    [self.tableview reloadData];
    //点击哪里把中心点传到被点击的地方
    _arrow.center=CGPointMake(_arrow.center.x, sender.center.y);
}
#pragma mark 网络音乐
- (IBAction)netMusic:(UIButton *)sender {
    sender.selected=YES;
    _myMusicbtn.selected=NO;
    _morebtn.selected=NO;
    _musicSel=eNetMusic;//点击了哪个按钮，用这个枚举变量标记你选择的哪一个选
      _cellStatus=nil;//在刷新之前，把懒加载置成nil才能加载
    _curselectedrow=-1;//每次切换置成－1
    //点击之后应该刷新一下tableview
     [self.tableview reloadData];
    //点击哪里把中心点传到被点击的地方
    _arrow.center=CGPointMake(_arrow.center.x, sender.center.y);
}
#pragma mark 更多功能
- (IBAction)moreFunction:(UIButton *)sender {
    sender.selected=YES;
    _myMusicbtn.selected=NO;
    _netMusicbtn.selected=NO;
    _musicSel=eMoreFounction;//点击了哪个按钮，用这个枚举变量标记你选择的哪一个选项
    //在刷新之前，把懒加载置成nil才能加载
      _cellStatus=nil;
    _curselectedrow=-1;//每次切换置成－1
    //点击之后应该刷新一下tableview
     [self.tableview reloadData];
    //点击哪里把中心点传到被点击的地方
    _arrow.center=CGPointMake(_arrow.center.x, sender.center.y);
    
}
@end
