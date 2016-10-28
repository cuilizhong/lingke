//
//  MainTabBarController.m
//
//  Created by qiang11.wei on 16/4/22.
//

#import "MainTabBarController.h"
#import "ConfigureColor.h"

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
    
    UITabBar.appearance.tintColor = [ConfigureColor sharedInstance].highBlue;
    
//    750*130   1242*196
    UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:4];

    
    item0.selectedImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"waittinghand_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"waittinghand"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"btn_card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"btn_card_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.title = @"";
    
    item3.selectedImage = [[UIImage imageNamed:@"message_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item4.selectedImage = [[UIImage imageNamed:@"my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
