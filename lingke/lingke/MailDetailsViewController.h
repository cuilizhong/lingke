//
//  MailDetailsViewController.h
//  lingke
//
//  Created by clz on 16/9/5.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "BasicTableViewController.h"
#import "PersionModel.h"


typedef NS_ENUM(NSUInteger, MailDetailsStatus) {
    MailDetailsStatus_ADD,
    MailDetailsStatus_LOCAL,
    MailDetailsStatus_SYSTEM,
    MailDetailsStatus_PRIVATE
    
};

@interface MailDetailsViewController : BasicTableViewController

@property(nonatomic,assign)MailDetailsStatus mailDetailsStatus;

@property(nonatomic,strong)HomeappModel *homeappModel;

@property(nonatomic,strong)PersionModel *persion;


@end
