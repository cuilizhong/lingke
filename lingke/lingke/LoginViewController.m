//
//  LoginViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "UIScrollView+TouchEvent.h"
#import "MainTabBarController.h"
@implementation LoginViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.scrollEnabled = NO;
    
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"image_1"]];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LoginTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"LoginTableViewCell" owner:self options:nil]objectAtIndex:indexPath.row];
    
    if (indexPath.row == 4) {
        
         __weak typeof(self)weakSelf = self;
        
        [cell showCellWithEntrySystemBlock:^{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            MainTabBarController *mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            
            [weakSelf.navigationController pushViewController:mainTabBarController animated:YES];
            
        }];
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return (self.view.frame.size.height-165)/2.0 - 50;
        
    }else if (indexPath.row == 1){
        
        return 55.0f;
    
    }else if (indexPath.row == 2){
        
        return 55.0f;
        
    }else if (indexPath.row == 3){
        
        return 55.0f;
        
    }else{
        
        return (self.view.frame.size.height-165)/2.0 + 50;

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
