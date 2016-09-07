//
//  MailDetailsViewController.m
//  lingke
//
//  Created by clz on 16/9/5.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailDetailsViewController.h"

typedef NS_ENUM(NSInteger, EditSate)
{
    EditStateEdit,
    
    EditStateSave
};

@interface MailDetailsViewController ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *addressTableViewCell;


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *sexTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *fixedTelephoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *roleTextField;

@property (weak, nonatomic) IBOutlet UITextField *groupTextField;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UISwitch *myFriendsSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *myGroundSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *myFollowSwitch;

@property (assign, nonatomic)CGFloat addressCellHeight;

@property (strong, nonatomic)UIBarButtonItem *rightBarButton;

@property (assign, nonatomic)EditSate editSate;

@end

@implementation MailDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.addressCellHeight = 60.0f;
    
    if (self.isAdd) {
        
        self.rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
        
        self.editSate = EditStateSave;

    }else{
        
        //判断是否可以编辑（系统的不可编辑）
        if (self.isEdit) {
            
            self.rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
            
            self.navigationItem.rightBarButtonItem = self.rightBarButton;
            
            self.editSate = EditStateEdit;

        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.isAdd) {
        
        [self.usernameTextField becomeFirstResponder];
    }
}

#pragma mark-保存
- (void)saveAction:(UIBarButtonItem *)sender{
    
    if (self.usernameTextField.text.length<1) {
        
        NSLog(@"缺少username");
        
        return;
    }
    
    if (self.phoneNumberTextField.text.length<1) {
        
        NSLog(@"缺少phoneNumber");
        
        return;
    }
    
    
    //上传
    NSDictionary *person = @{
                             
                           @"username":self.usernameTextField.text,
                           
                           @"mobile":self.phoneNumberTextField.text,
                           
                           @"phone":(self.fixedTelephoneTextField.text.length>0)?self.fixedTelephoneTextField.text:@"",
                           
                           @"gender":(self.sexTextField.text.length>0)?self.sexTextField.text:@"",
                           
                           @"email":(self.emailTextField.text.length>0)?self.emailTextField.text:@"",
                           
                           @"orgname":@"",
                           
                           @"deptname":(self.departmentTextField.text.length>0)?self.departmentTextField.text:@"",
                           
                           @"address":(self.addressTextView.text.length>0)?self.addressTextView.text:@"",

                           @"rolename":(self.roleTextField.text.length>0)?self.roleTextField.text:@"",
                           
                           @"groupname":(self.groupTextField.text.length>0)?self.groupTextField.text:@""
                           
                           };
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":self.homeappModel.appcode,
                                  
                                  @"method":@"PERSONADD",
                                  
                                  @"person":person
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self)
    
    [HttpsRequestManger sendHttpReqestWithUrl:self.homeappModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
    } requestFail:^(NSError *error) {
        
    }];
    
}

#pragma mark-编辑
- (void)editAction:(UIBarButtonItem *)sender{
    
    if (self.editSate == EditStateEdit) {
        
        self.editSate = EditStateSave;
        
        [self.rightBarButton setTitle:@"保存"];
        
        self.headImageView.userInteractionEnabled = YES;
        self.usernameTextField.enabled = YES;
        self.sexTextField.enabled = YES;
        self.phoneNumberTextField.enabled = YES;
        self.departmentTextField.enabled = YES;
        self.emailTextField.enabled = YES;
        self.fixedTelephoneTextField.enabled = YES;
        self.addressTextView.editable = YES;
        self.myFriendsSwitch.enabled = YES;
        self.myGroundSwitch.enabled = YES;
        self.myFollowSwitch.enabled = YES;

        
    }else{
        
        [self saveAction:sender];
    }
    
}


#pragma mark-UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}


#pragma mark-UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 120.0f;
        
    }else if (indexPath.row == 9) {
        
        return self.addressCellHeight;
        
    }else{
        
        return 44.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    if (self.addressTextView.text.length<1) {
        
        return;
    }
    
    //调整地址cell的高度
    CGFloat width = self.view.frame.size.width - 96 - 8;
    
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:self.addressTextView.text attributes:attributesDic];
    
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    
    CGRect rect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    CGFloat height = rect.size.height + 30;
    
    //刷新某一个cell
    self.addressCellHeight = MAX(60, height);
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
