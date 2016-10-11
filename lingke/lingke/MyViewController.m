//
//  MyViewController.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MyViewController.h"
#import "UIImageView+WebCache.h"
#import "AttachmentViewController.h"

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.cornerRadius = 35.0f;
    self.headImageView.clipsToBounds = YES;
    
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[LocalData getCustomerlogo]] placeholderImage:[UIImage imageNamed:@"DefaultPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [self hiddenSurplusLine:self.tableView];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        
        //帮助
        
    }else if (indexPath.row == 4){
        
        //我的附件
        AttachmentViewController *attachmentViewController = [[AttachmentViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:attachmentViewController animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
