//
//  TutorialsViewController.m
//  lingke
//
//  Created by clz on 16/8/23.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "TutorialsViewController.h"
#import "UIImageView+WebCache.h"

@interface TutorialsViewController()

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation TutorialsViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *self.tutorialsArray.count, self.view.frame.size.height);
    
    
    for (int i = 0; i<self.tutorialsArray.count; i++) {
        
        TutorialsModel *tutorialsModel = self.tutorialsArray[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:tutorialsModel.picurl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [self.scrollView addSubview:imageView];
    }
    
    [self.view addSubview:self.scrollView];
}

@end
