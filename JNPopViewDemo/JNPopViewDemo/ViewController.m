//
//  ViewController.m
//  JNPopViewDemo
//
//  Created by Jiangergo Pk Czt on 16/9/6.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "ViewController.h"
#import "JNDropDownMenu.h"

@interface ViewController ()<JNDropDownMenuDelegate, JNDropDownMenuDataSource>

@property (nonatomic, strong) NSArray *rightDataArray;

@property (nonatomic, strong) NSArray *leftDataArray;

@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _rightDataArray = @[@"全部",@"同城",@"北京",@"上海"];
    _leftDataArray = @[
                       @[@"全部"],
                       @[@"附近",@"500米",@"1000米",@"2000米",@"5000米"],
                       @[@"三里屯",@"亚运村",@"朝阳公园"],
                       @[@"徐家汇",@"人民广场",@"陆家嘴"],
                       ];
    _currentArray = _leftDataArray[0];
    
}

#pragma mark -设置UI
- (void)setupUI{
    
    self.title = @"JNDropDownMenu";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *activityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 62, 30)];
    
    [activityButton setTitle:@"菜单" forState:UIControlStateNormal];
    [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    activityButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [activityButton setImage:[UIImage imageNamed:@"expandableImage"] forState:UIControlStateNormal];
    activityButton.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
    
    [activityButton addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityButton];
    
    
    // 初始化menu
    JNDropDownMenu *menu = [[JNDropDownMenu alloc]initWithOrigin:CGPointMake(0, 64) height:300];
    
    menu.transformView = activityButton.imageView;
    menu.tag = 1001;
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];

}


#pragma mark -按钮点击事件
- (void)activityButtonAction:(UIButton *)sender{
    
    JNDropDownMenu *menu = (JNDropDownMenu *)[self.view viewWithTag:1001];
    
    [UIView animateWithDuration:0.25 animations:^{
        
    } completion:^(BOOL finished) {
        [menu menuPresent];
    }];
}

#pragma mark -选择menu选项后修改activityButton的方法
- (void)resetActivityButtonWithTitle:(NSString *)title{
    UIButton *button = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [button setTitle:title forState:UIControlStateNormal];
    CGSize size = [title boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:button.titleLabel.font } context:nil].size;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, size.width + 32, 30);
    button.imageEdgeInsets = UIEdgeInsetsMake(11, size.width + 23, 11, 0);
}

#pragma mark -menu dataSource
- (NSInteger)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == menu.rightTableView) {
        return _rightDataArray.count;
    }else {
        return _currentArray.count;
    }
    
}
- (NSString *)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        return _rightDataArray[indexPath.row];
    }else {
        return _currentArray[indexPath.row];
    }
}

#pragma mark -menu delegate
- (void)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        if (indexPath.row == 0) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSArray *arr in _leftDataArray) {
                [mArr addObjectsFromArray:arr];
            }
            _currentArray = mArr;
            [menu.leftTableView reloadData];
            return;
        }
        _currentArray = _leftDataArray [indexPath.row];
        [menu.leftTableView reloadData];
    }else {
        [self resetActivityButtonWithTitle:_currentArray[indexPath.row]];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
