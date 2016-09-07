//
//  MenusView.m
//  lingke
//
//  Created by clz on 16/9/6.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MenusView.h"
#import "ExtendappCell.h"


@interface MenusView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *menusTitleArray;

@property(nonatomic,strong)SelectedBlock selectedBlock;

@property(nonatomic,copy)NSString *selectedTitle;

@end

@implementation MenusView

- (instancetype)initWithFrame:(CGRect)frame menusTitle:(NSMutableArray<NSString *>*)menusTitle selectedBlock:(SelectedBlock)selectedBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.size.width/2.0-frame.size.height/2.0, -(frame.size.width/2.0-frame.size.height/2.0), frame.size.height, frame.size.width) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self addSubview:self.tableView];
        
        self.menusTitleArray = menusTitle;
        
        self.selectedTitle = menusTitle.firstObject;
        
        self.selectedBlock = selectedBlock;
    }
    
    return self;
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.menusTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"MenusViewCellID";
    
    ExtendappCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[ExtendappCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *title = self.menusTitleArray[indexPath.row];
    
    @weakify(self);
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:title attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(1000, MAXFLOAT);
    
    CGRect rect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];

    [cell showCellWithMenuTitle:title cellSize:CGSizeMake(40, rect.size.width+10+10) clickMenuBlock:^(NSString *menuTitle) {
        
        weakself.selectedTitle = menuTitle;
        
        weakself.selectedBlock(menuTitle);
        
        [weakself.tableView reloadData];
        
    }];
    
    if ([title isEqualToString:self.selectedTitle]) {
        
        cell.menuButton.backgroundColor = [UIColor blueColor];
        
        [cell.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
    }else{
        
        cell.menuButton.backgroundColor = [UIColor whiteColor];
        
        [cell.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.menusTitleArray[indexPath.row];
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:title attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(1000, MAXFLOAT);
    
    CGRect rect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    return rect.size.width + 10+10;
}



@end
