//
//  MyFriendViewController.h
//  lingke
//
//  Created by clz on 16/10/4.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicViewController.h"

//我的好友、我的群组、我的关注
typedef NS_ENUM(NSInteger,MailListState){
    
    MailListState_Friend,//我的好友
    MailListState_Grounp,//我的群组
    MailListState_Follow //我的关注
};


@interface MyFriendViewController : BasicViewController

@property(nonatomic,assign)MailListState mailListState;

@property(nonatomic,strong)HomeappModel *homeappModel;


@end
