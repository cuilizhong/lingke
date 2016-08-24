//
//  MainTabBarController.m
//
//  Created by qiang11.wei on 16/4/22.
//

#import "MainTabBarController.h"

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -8, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"tabbar_bg"]];
    [imageView setContentMode:UIViewContentModeCenter];
    [self.tabBar insertSubview:imageView atIndex:0];
    //覆盖原生Tabbar的上横线
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    //设置TintColor
    UITabBar.appearance.tintColor = [UIColor orangeColor];
}


-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


//设置中间按钮不受TintColor影响
- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *items =  self.tabBar.items;
    UITabBarItem *btnAdd = items[2];
    btnAdd.image = [btnAdd.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btnAdd.selectedImage = [btnAdd.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
