//
//  MyViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MyViewController.h"
#import "UIImageView+WebCache.h"

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.cornerRadius = 35.0f;
    self.headImageView.clipsToBounds = YES;
    
    self.title = @"个人中心";
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LocalData getCustomerlogo]] placeholderImage:[UIImage imageNamed:@"DefaultPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [self hiddenSurplusLine:self.tableView];

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
