//
//  JNDropDownMenu.h
//  JNPopViewDemo
//
//  Created by Jiangergo Pk Czt on 16/9/6.
//  Copyright © 2016年 jiangergo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNDropDownMenu;
@protocol JNDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol JNDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(JNDropDownMenu *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JNDropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id<JNDropDownMenuDelegate> delegate;

@property (nonatomic, weak) id<JNDropDownMenuDataSource> dataSource;


- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height;

- (void)menuPresent;

@end
