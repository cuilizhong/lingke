//
//  MyViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MyViewController.h"
#import "UserinfoModel.h"
#import "UIImageView+WebCache.h"

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishNameLabel;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.cornerRadius = 35.0f;
    self.headImageView.clipsToBounds = YES;
    
    self.title = @"个人中心";
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserinfoModel sharedInstance].headurl] placeholderImage:[UIImage imageNamed:@"DefaultPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.usernameLabel.text = [UserinfoModel sharedInstance].username;
    self.englishNameLabel.text = [UserinfoModel sharedInstance].unitname;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 4) {
        
        //帮助
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
