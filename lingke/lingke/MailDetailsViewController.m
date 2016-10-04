//
//  MailDetailsViewController.m
//  lingke
//
//  Created by clz on 16/9/5.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "MailDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"


@interface MailDetailsViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;


@property (weak, nonatomic) IBOutlet UITableViewCell *addressTableViewCell;


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

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

@property (assign, nonatomic)NSInteger sex;

@property (strong, nonatomic)NSData *headImageData;

@end

@implementation MailDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    
    [self.headImageView addGestureRecognizer:singleTapGestureRecognizer];
    
    if (self.persion) {
        
        //编辑
        if ([self.persion.kind isEqualToString:@"SYSTEM"]) {
            //系统的不可以编辑
            
        }else if([self.persion.kind isEqualToString:@"PRIVATE"]){
            //个人的可以编辑
            
            if (!self.isLocal) {
                
                self.rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
                
                self.navigationItem.rightBarButtonItem = self.rightBarButton;
                
                self.isEdit = YES;
            }
            
            
        }
        
    }else{
        
        //新增
        self.rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
        
        self.isAdd = YES;
    }
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;

    self.addressCellHeight = 44.0f;
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender{
    
    if (self.persion) {
        
        [self insertPersionToLocal];

    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-赋值
- (void)setInitValue{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.persion.headurl] placeholderImage:[UIImage imageNamed:@"DefaultPhoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.usernameTextField.text = self.persion.username;
    self.sex = self.persion.gender.integerValue;
    
    if (self.sex == 1) {
        
        [self.maleButton setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateNormal];
        
        [self.femaleButton setImage:[UIImage imageNamed:@"勾-_未选中"] forState:UIControlStateNormal];
        
       
        
    }else if(self.sex == 2){
        
        [self.maleButton setImage:[UIImage imageNamed:@"勾-_未选中"] forState:UIControlStateNormal];
        
        [self.femaleButton setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateNormal];
    }
    
    self.phoneNumberTextField.text = self.persion.mobile;
    self.departmentTextField.text = self.persion.deptname;
    self.emailTextField.text = self.persion.email;
    self.fixedTelephoneTextField.text = self.persion.phone;
    self.addressTextView.text = self.persion.address;
    self.myFriendsSwitch.on = self.persion.isfriend.boolValue;
    self.myGroundSwitch.on = self.persion.ismygroup.boolValue;
    self.myFollowSwitch.on = self.persion.isattention.boolValue;
    self.roleTextField.text = self.persion.rolename;
    self.groupTextField.text = self.persion.groupname;
    
}

- (void)addPersion{
    
    self.headImageView.userInteractionEnabled = YES;
    self.usernameTextField.enabled = YES;
    self.phoneNumberTextField.enabled = YES;
    self.departmentTextField.enabled = YES;
    self.emailTextField.enabled = YES;
    self.fixedTelephoneTextField.enabled = YES;
    self.addressTextView.editable = YES;
    self.myFriendsSwitch.enabled = YES;
    self.myGroundSwitch.enabled = YES;
    self.myFollowSwitch.enabled = YES;
    self.roleTextField.enabled = YES;
    self.groupTextField.enabled = YES;
    
    self.maleButton.enabled = YES;
    self.femaleButton.enabled = YES;
    
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self upload];

    if (self.isAdd) {
        
        [self addPersion];
        
    }else{
        
        [self setInitValue];

    }
    
    
}

#pragma mark-更新
- (void)update{
    
    [self showHUDWithMessage:@"添加中"];
    
    if (self.usernameTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写用户名"];
        
        return;
    }
    
    if (self.phoneNumberTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写手机号码"];
        
        return;
    }
    
    if (self.sex != 1 && self.sex != 2) {
        
        [self hiddenHUDWithMessage:@"请选择性别"];
        
        return;
    }
    

    
    //上传
    NSDictionary *person = @{
                             
                             @"pid":self.persion.pid,
                             
                             @"username":self.usernameTextField.text,
                             
                             @"mobile":self.phoneNumberTextField.text,
                             
                             @"phone":(self.fixedTelephoneTextField.text.length>0)?self.fixedTelephoneTextField.text:@"",
                             
                             @"gender":[NSString stringWithFormat:@"%ld",(long)self.sex],
                             
                             @"email":(self.emailTextField.text.length>0)?self.emailTextField.text:@"",
                             
                             @"orgname":@"",
                             
                             @"deptname":(self.departmentTextField.text.length>0)?self.departmentTextField.text:@"",
                             
                             @"address":(self.addressTextView.text.length>0)?self.addressTextView.text:@"",
                             
                             @"rolename":(self.roleTextField.text.length>0)?self.roleTextField.text:@"",
                             
                             @"groupname":(self.groupTextField.text.length>0)?self.groupTextField.text:@"",
                             
                             @"isattention":[NSString stringWithFormat:@"%d",self.myFollowSwitch.on],
                             
                             @"isfriend":[NSString stringWithFormat:@"%d",self.myFriendsSwitch.on],
                             
                             @"ismygroup":[NSString stringWithFormat:@"%d",self.myGroundSwitch.on]
                             
                             
                             };
    
    [self.persion setValueFromDic:person];
    
    NSDictionary *requestdata = @{
                                  
                                  @"appcode":self.homeappModel.appcode,
                                  
                                  @"method":@"PERSONUPDATE",
                                  
                                  @"person":person
                                  
                                  };
    
    NSDictionary *parameters = @{
                                 
                                 @"token":[LocalData getToken],
                                 
                                 @"requestdata":requestdata,
                                 
                                 };
    
    @weakify(self)
    
    [HttpsRequestManger sendHttpReqestWithUrl:self.homeappModel.appuri parameter:parameters requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            [weakself hiddenHUDWithMessage:@"已保存"];
            
        }else if([xmlDoc[@"statuscode"] isEqualToString:TokenInvalidCode]){
            
            [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:^{
                
                [weakself update];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:RequestFailureMessage];
                
            }];
            
        }else{
            
            [weakself hiddenHUDWithMessage:xmlDoc[@"statusmsg"]];
            
        }
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
}

- (void)save{
    
    [self showHUDWithMessage:@"添加中"];
    
    if (self.usernameTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写用户名"];
        
        return;
    }
    
    if (self.phoneNumberTextField.text.length<1) {
        
        [self hiddenHUDWithMessage:@"请填写手机号码"];
        
        return;
    }
    
    if (self.sex != 1 && self.sex != 2) {
        
        [self hiddenHUDWithMessage:@"请选择性别"];
        
        return;
    }
    
    
    //上传
    NSDictionary *person = @{
                             
                             @"username":self.usernameTextField.text,
                             
                             @"mobile":self.phoneNumberTextField.text,
                             
                             @"phone":(self.fixedTelephoneTextField.text.length>0)?self.fixedTelephoneTextField.text:@"",
                             
                             @"gender":[NSString stringWithFormat:@"%ld",(long)self.sex],
                             
                             @"email":(self.emailTextField.text.length>0)?self.emailTextField.text:@"",
                             
                             @"orgname":@"",
                             
                             @"deptname":(self.departmentTextField.text.length>0)?self.departmentTextField.text:@"",
                             
                             @"address":(self.addressTextView.text.length>0)?self.addressTextView.text:@"",
                             
                             @"rolename":(self.roleTextField.text.length>0)?self.roleTextField.text:@"",
                             
                             @"groupname":(self.groupTextField.text.length>0)?self.groupTextField.text:@"",
                             
                             @"isattention":[NSString stringWithFormat:@"%d",self.myFollowSwitch.on],
                             
                             @"isfriend":[NSString stringWithFormat:@"%d",self.myFriendsSwitch.on],
                             
                             @"ismygroup":[NSString stringWithFormat:@"%d",self.myGroundSwitch.on]
                             
                             
                             };
    
    
    if (!self.persion) {
        
        self.persion = [[PersionModel alloc]init];
    }
    
    [self.persion setValueFromDic:person];
    
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
        
        if ([xmlDoc[@"statuscode"] isEqualToString:@"0"]) {
            
            [weakself hiddenHUDWithMessage:@"已保存"];
            
        }else if([xmlDoc[@"statuscode"] isEqualToString:TokenInvalidCode]){
            
            [HttpsRequestManger sendHttpReqestForExpireWithExpireLoginSuccessBlock:^{
                
                [weakself save];
                
            } expireLoginFailureBlock:^(NSString *errorMessage) {
                
                [weakself hiddenHUDWithMessage:RequestFailureMessage];
                
            }];
            
        }else{
            
            [weakself hiddenHUDWithMessage:xmlDoc[@"statusmsg"]];
            
        }
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
    } requestFail:^(NSError *error) {
        
        [weakself hiddenHUDWithMessage:RequestFailureMessage];
        
    }];
}


#pragma mark-保存
- (void)saveAction:(UIBarButtonItem *)sender{
    
    if (self.isAdd) {
        
        [self save];
    }
    
    if (self.isEdit) {
        
        [self update];

    }
  
}

#pragma mark-编辑
- (void)editAction:(UIBarButtonItem *)sender{
    
    if ([self.rightBarButton.title isEqualToString:@"编辑"]) {
        
        [self.rightBarButton setTitle:@"保存"];
        
        self.headImageView.userInteractionEnabled = YES;
        self.usernameTextField.enabled = YES;
        self.phoneNumberTextField.enabled = YES;
        self.departmentTextField.enabled = YES;
        self.emailTextField.enabled = YES;
        self.fixedTelephoneTextField.enabled = YES;
        self.addressTextView.editable = YES;
        self.myFriendsSwitch.enabled = YES;
        self.myGroundSwitch.enabled = YES;
        self.myFollowSwitch.enabled = YES;
        self.roleTextField.enabled = YES;
        self.groupTextField.enabled = YES;
        
        
        self.maleButton.enabled = YES;
        self.femaleButton.enabled = YES;
   

        
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
    
    CGFloat height = rect.size.height + 14;
    
    //刷新某一个cell
    self.addressCellHeight = MAX(44, height);
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark-设为常用联系人
- (void)insertPersionToLocal{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate update:self.persion];
}

- (IBAction)maleAction:(id)sender {
    //男
    self.sex = 1;
    
    [self.maleButton setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateNormal];
    
    [self.femaleButton setImage:[UIImage imageNamed:@"勾-_未选中"] forState:UIControlStateNormal];
}

- (IBAction)femaleAction:(id)sender {
    //女
    self.sex = 2;
    
    [self.maleButton setImage:[UIImage imageNamed:@"勾-_未选中"] forState:UIControlStateNormal];
    
    [self.femaleButton setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateNormal];
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takephotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断是否可以打开相机，模拟器此功能无法使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;  //是否可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }else{
            
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缺少摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }];
    
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;  //是否可编辑
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"提示" message:@"你没有相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:takephotoAction];
    [alert addAction:choosePhotoAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.headImageView.image = image;
    
    self.headImageData = UIImageJPEGRepresentation(image, 0.1);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)upload{
    
    NSString *token = [LocalData getToken];
    
    NSString *URL = [LocalData getLoginInterface];
    
    URL = [NSString stringWithFormat:@"%@/dataapi/attach/upload?token=%@",URL,token];
    
    [[Network alloc]initUploadImageWithURL:URL image:self.headImageData requestSuccess:^(NSData *data) {
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
        
        NSLog(@"xmlDoc = %@",xmlDoc);
        
        
    } requestFail:^(NSError *error) {
        
    }];
}

@end
