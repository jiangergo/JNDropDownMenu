//
//  JNDropDownMenu.m
//  JNPopViewDemo
//
//  Created by Jiangergo Pk Czt on 16/9/6.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import "JNDropDownMenu.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface JNDropDownMenu ()

/// 初始化的点
@property (nonatomic, assign) CGPoint origin;

/// 高度
@property (nonatomic, assign) CGFloat height;

/// 蒙版
@property (nonatomic, strong) UIView *backGroundView;

/// 记录是否显示的属性
@property (nonatomic, assign) BOOL isShow;

@end

@implementation JNDropDownMenu

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height{
    
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREENW, 0)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _origin = origin;
        _isShow = NO;
        _height = height;
        
        // 初始化tableView
//        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(origin.x + self.frame.origin.y, self.frame.origin.y, SCREENW * 0.7, 0) style:UITableViewStylePlain];
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, SCREENW*0.7, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = 38;
        _leftTableView.tableFooterView = [[UIView alloc]init];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
//        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftTableView.frame), self.frame.origin.y, SCREENW * 0.3, 0) style:UITableViewStylePlain];
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+ SCREENW * 0.7, self.frame.origin.y + self.frame.size.height, SCREENW * 0.3, 0) style:UITableViewStylePlain];
        _rightTableView.rowHeight = 38;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        // 初始化backGroundView
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackGroundView:)];
        [_backGroundView addGestureRecognizer:gesture];
    }
    
    return self;
}

#pragma mark -gesture method

// 供外界调用展示/隐藏menu的方法
- (void)menuPresent{
    if (!_isShow) {
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [self animationBackGroundView:self.backGroundView show:!_isShow complete:^{
        [self animationTableViewShow:!_isShow complete:^{
            [self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _isShow = !_isShow;
        }];
    }];
    
}

// 蒙版的手势方法
- (void)tapBackGroundView:(UITapGestureRecognizer *)sender{
    [self animationBackGroundView:_backGroundView show:NO complete:^{
        [self animationTableViewShow:NO complete:^{
            _isShow = NO;
        }];
    }];
}


#pragma mark -animation method

- (void)animationTableViewShow:(BOOL)show complete:(void(^)())complete{
    
    if (show) {
        _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, SCREENW * 0.7, 0);
        [self.superview addSubview:_leftTableView];
//        _rightTableView.frame = CGRectMake(CGRectGetMaxX(_leftTableView.frame), self.frame.origin.y, SCREENW * 0.3, 0);
        _rightTableView.frame = CGRectMake(self.origin.x+SCREENW * 0.7, self.frame.origin.y, SCREENW * 0.3, 0);
        [self.superview addSubview:_rightTableView];
        
        _leftTableView.alpha = 1.f;
        _rightTableView.alpha = 1.f;
        
        [UIView animateWithDuration:0.25 animations:^{
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, SCREENW * 0.7, _height);
            _rightTableView.frame = CGRectMake(self.origin.x+SCREENW * 0.7, self.frame.origin.y, SCREENW * 0.3, _height);
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            _leftTableView.alpha = 0.f;
            _rightTableView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
            
        } completion:^(BOOL finished) {
            [_leftTableView removeFromSuperview];
            [_rightTableView removeFromSuperview];
        }];
    }
    complete();
}

// 蒙版的动画方法
- (void)animationBackGroundView:(UIView *)backGroundView show:(BOOL)isShow complete:(void(^)())complete{
    if (isShow) {
        [self.superview addSubview:backGroundView];
        [backGroundView.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [backGroundView removeFromSuperview];
        }];
    }
    complete();
}



#pragma mark -tableView dateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        return [self.dataSource menu:self tableView:tableView numberOfRowsInSection:section];
    }else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseID = @"JNDropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    }else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
    }
    
    if (tableView == _leftTableView) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        UIView *selectView = [[UIView alloc]init];
        selectView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectView;
        [cell setSelected:YES animated:NO];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}




#pragma mark -tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        if (tableView == self.leftTableView) {
            [self animationBackGroundView:_backGroundView show:NO complete:^{
                [self animationTableViewShow:NO complete:^{
                    _isShow = NO;
                }];
            }];
        }
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else {
        // TODO: delegate is nil
    }
    
}



@end



