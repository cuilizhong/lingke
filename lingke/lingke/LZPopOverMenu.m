//
//  LZPopOverMenu.m
//  LZPopOverMenu
//
//  Created by clz on 16/8/22.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LZPopOverMenu.h"

#define KSCREEN_WIDTH               [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT              [[UIScreen mainScreen] bounds].size.height
#define FTBackgroundColor           [UIColor clearColor]
#define FTDefaultTintColor          [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.f]
#define FTDefaultTextColor          [UIColor whiteColor]
#define FTDefaultMenuFont           [UIFont systemFontOfSize:14]
#define FTDefaultMenuWidth          120.0
#define FTDefaultMenuIconWidth      20.0
#define FTDefaultMenuRowHeight      40.0
#define FTDefaultMenuArrowHeight    10.0
#define FTDefaultMenuArrowWidth     7.0
#define FTDefaultMenuCornerRadius   4.0
#define FTDefaultMargin             4.0
#define FTDefaultAnimationDuration  0.2

#define LZPopOverMenuTableViewCellIndentifier @"LZPopOverMenuTableViewCellIndentifier"

typedef void(^LZPopOverMenuDoneBlock)(NSInteger selectedIndex);

typedef void (^LZPopOverMenuDismissBlock)();


typedef NS_ENUM(NSUInteger, LZPopOverMenuArrowDirection) {
    /**
     *  Up
     */
    LZPopOverMenuArrowDirectionUp,
    /**
     *  Down
     */
    LZPopOverMenuArrowDirectionDown,
};

@implementation LZPopOverMenuCell


@end

@interface LZPopOverMenuView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *menuTableView;

@property(nonatomic,strong)NSArray<NSString *> *menuStringArray;

@property(nonatomic,strong)NSArray<NSString *> *menuIconNameArray;

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@property (nonatomic,strong)UIColor *tintColor;



/**
 *  控制方向
 */
@property(nonatomic,assign)LZPopOverMenuArrowDirection arrowDirection;

@property(nonatomic,strong)LZPopOverMenuDoneBlock doneBlock;


@property(nonatomic,assign)BOOL isDispalyHeader;
@property(nonatomic,assign)BOOL isDisplayFooter;

@end

@implementation LZPopOverMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.menuTableView.delegate = self;
        
        self.menuTableView.dataSource = self;
        
        self.menuTableView.separatorColor = [UIColor grayColor];

        self.menuTableView.backgroundColor = FTBackgroundColor;
        
        self.menuTableView.layer.cornerRadius = FTDefaultMenuCornerRadius;

        self.menuTableView.separatorInset = UIEdgeInsetsMake(0, FTDefaultMargin, 0, FTDefaultMargin);
        
        self.menuTableView.scrollEnabled = NO;
        
        self.menuTableView.clipsToBounds = YES;



        [self addSubview:self.menuTableView];
    }
    
    return self;
}

-(void)showWithAnglePoint:(CGPoint)anglePoint
            withNameArray:(NSArray<NSString*> *)nameArray
           imageNameArray:(NSArray<NSString*> *)imageNameArray
         shouldAutoScroll:(BOOL)shouldAutoScroll
           arrowDirection:(LZPopOverMenuArrowDirection)arrowDirection
                doneBlock:(LZPopOverMenuDoneBlock)doneBlock{
    
    self.menuStringArray = nameArray;
    
    self.menuIconNameArray = imageNameArray;
    
    self.arrowDirection = arrowDirection;
    
    self.doneBlock = doneBlock;
    
    if (self.menuStringArray.count>10) {
        
        self.isDisplayFooter = YES;
        
    }
    
    [self.menuTableView reloadData];
    
    self.menuTableView.scrollEnabled = YES;
    
    switch (self.arrowDirection) {
            
        case LZPopOverMenuArrowDirectionUp:
            
            self.menuTableView.frame = CGRectMake(0, FTDefaultMenuArrowHeight, self.frame.size.width, self.frame.size.height - FTDefaultMenuArrowHeight);
            
            break;
            
        case LZPopOverMenuArrowDirectionDown:
            
            self.menuTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - FTDefaultMenuArrowHeight);

            
            break;
            
        default:
            break;
    }
    
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}

-(void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint{
    
    //画角
    if (self.backgroundLayer) {
        
        [self.backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    switch (self.arrowDirection) {
            
        case LZPopOverMenuArrowDirectionUp:{
            
            [path moveToPoint:anglePoint];
            [path addLineToPoint:CGPointMake( anglePoint.x - FTDefaultMenuArrowWidth, FTDefaultMenuArrowHeight)];
            [path addLineToPoint:CGPointMake( FTDefaultMenuCornerRadius, FTDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, FTDefaultMenuArrowHeight + FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake( 0, self.bounds.size.height - FTDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, self.bounds.size.height - FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - FTDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, self.bounds.size.height - FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , FTDefaultMenuCornerRadius + FTDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, FTDefaultMenuCornerRadius + FTDefaultMenuArrowHeight) radius:FTDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake(anglePoint.x + FTDefaultMenuArrowWidth, FTDefaultMenuArrowHeight)];
            [path closePath];

            
        }
            
            break;
            
        case LZPopOverMenuArrowDirectionDown:{
            
            
            [path moveToPoint:anglePoint];
            [path addLineToPoint:CGPointMake( anglePoint.x - FTDefaultMenuArrowWidth, anglePoint.y - FTDefaultMenuArrowHeight)];
            [path addLineToPoint:CGPointMake( FTDefaultMenuCornerRadius, anglePoint.y - FTDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, anglePoint.y - FTDefaultMenuArrowHeight - FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0, FTDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - FTDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (FTDefaultMenuCornerRadius + FTDefaultMenuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, anglePoint.y - (FTDefaultMenuCornerRadius + FTDefaultMenuArrowHeight)) radius:FTDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake(anglePoint.x + FTDefaultMenuArrowWidth, anglePoint.y - FTDefaultMenuArrowHeight)];
            [path closePath];
        }
            
            break;
            
        default:
            break;
    }
    
    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.path = path.CGPath;
    self.backgroundLayer.fillColor = self.tintColor ? self.tintColor.CGColor : FTDefaultTintColor.CGColor;
    self.backgroundLayer.strokeColor = self.tintColor ? self.tintColor.CGColor : FTDefaultTintColor.CGColor;
    [self.layer insertSublayer:self.backgroundLayer atIndex:0];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.menuStringArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LZPopOverMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:LZPopOverMenuTableViewCellIndentifier];
    
    if (!cell) {
        
        cell = [[LZPopOverMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LZPopOverMenuTableViewCellIndentifier];
        
        cell.backgroundColor = [UIColor clearColor];

    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.menuStringArray[indexPath.row]];
        
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.doneBlock(indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    
    view.backgroundColor = FTBackgroundColor;
    
    view.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    imageView.center = view.center;
    imageView.image = [UIImage imageNamed:@"arrow_top"];
    [view addSubview:imageView];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    
    view.backgroundColor = FTBackgroundColor;
    
    view.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    imageView.center = view.center;
    imageView.image = [UIImage imageNamed:@"arrow_bottom"];
    [view addSubview:imageView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.isDispalyHeader) {
        
        return 25.0f;
        
    }else{
        
        return 0.01f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.isDisplayFooter) {
        
        return 25.0f;
        
    }else{
        
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"contentOffset.y = %f",scrollView.contentOffset.y);
    
    //计算位移
    if (scrollView.contentOffset.y <= 0) {
        
        self.isDispalyHeader = NO;
        self.isDisplayFooter = YES;
        
        [self.menuTableView reloadData];
    }
    
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height) {
        self.isDisplayFooter = NO;
        self.isDispalyHeader = YES;
        
        [self.menuTableView reloadData];
    }
}

- (void)reloadTableView{
    
    self.menuStringArray = @[@"test1",@"test1",@"test1",@"test1",@"test1",@"test1",@"test1",@"test1"];
    
    [self.menuTableView reloadData];
}

@end

@interface LZPopOverMenu()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *backgroundView;

@property(nonatomic,strong)UIView *sender;

@property(nonatomic,assign)CGRect senderFrame;

@property (nonatomic, strong) UIColor *tintColor;

@property(nonatomic,strong)LZPopOverMenuView *popMenuView;

@property(nonatomic,strong)LZPopOverMenuDoneBlock doneBlock;

@property(nonatomic,strong)LZPopOverMenuDismissBlock dismissBlock;

@property(nonatomic,strong)NSArray<NSString *>*menuArray;

@property(nonatomic,strong)NSArray<NSString *>*menuImageArray;

@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@end

@implementation LZPopOverMenu

static LZPopOverMenu *popOverMenu = nil;

+(instancetype )sharedInstance{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        popOverMenu = [[self alloc] init];
        
    });
    
    return popOverMenu;
}

#pragma mark - Public Method
+(void)showForSender:(UIView *)sender
            withMenu:(NSArray<NSString *>*)menuArray
      imageNameArray:(NSArray<NSString*> *)imageNameArray
           doneBlock:(LZPopOverMenuDoneBlock)doneBlock
        dismissBlock:(LZPopOverMenuDismissBlock)dismissBlock{
    
    [[self sharedInstance]showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageNameArray doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) dismiss{
    [[self sharedInstance]dismiss];
}


+ (void)setTintColor:(UIColor *)tintColor{
    
    [[self sharedInstance]setTintColor:tintColor];
}

#pragma mark - Private Methods
- (void)showForSender:(UIView *)sender
           senderFrame:(CGRect)senderFrame
              withMenu:(NSArray<NSString*> *)menuArray
        imageNameArray:(NSArray<NSString*> *)imageNameArray
             doneBlock:(LZPopOverMenuDoneBlock)doneBlock
          dismissBlock:(LZPopOverMenuDismissBlock)dismissBlock{
    
    [self initViews];
    
    self.sender = sender;
    
    self.senderFrame = senderFrame;
    
    self.menuArray = menuArray;
    
    self.menuImageArray = imageNameArray;
    
    self.doneBlock = doneBlock;
    
    self.dismissBlock = dismissBlock;
    
    //调整frame
    [self adjustPopOverMenu];
}

- (void)initViews{
    
    if (!self.backgroundView) {
        
        self.backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        
        tapGestureRecognizer.delegate = self;
        
        [self.backgroundView addGestureRecognizer:tapGestureRecognizer];
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
    }
    
    if (!self.popMenuView) {
        
        self.popMenuView = [[LZPopOverMenuView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        [self.backgroundView addSubview:self.popMenuView];
        
        self.popMenuView.alpha = 0;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
}

-(UIColor *)tintColor
{
    if (!_tintColor) {
        _tintColor = FTDefaultTintColor;
    }
    return _tintColor;
}

- (void)adjustPopOverMenu{
    
    CGRect senderRect;
    
    if (self.sender) {
        // self.sender所在视图转换到目标视图self.backgroundView中，返回在目标视图的坐标
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
        
    }else{
        
        senderRect = self.senderFrame;
    }
    
    if (senderRect.origin.y > KSCREEN_HEIGHT) {
        senderRect.origin.y = KSCREEN_HEIGHT;
    }
    
    CGFloat menuHeight;
    
    if (self.menuArray.count>10) {
        
        menuHeight = FTDefaultMenuRowHeight * 10 + FTDefaultMenuArrowHeight + 25;
        
    }else{
        
        menuHeight =  FTDefaultMenuRowHeight * self.menuArray.count + FTDefaultMenuArrowHeight;

    }
    
    
    
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width/2.0), 0);
    
    CGFloat menuX = 0;
    
    CGRect menuRect = CGRectZero;
    
    BOOL shouldAutoScroll = NO;
    
    LZPopOverMenuArrowDirection arrowDirection;

    if (senderRect.origin.y + senderRect.size.height/2.0 < KSCREEN_HEIGHT/2.0) {
        
        arrowDirection = LZPopOverMenuArrowDirectionUp;
        
        menuArrowPoint.y = 0;
        
    }else{
        
        arrowDirection = LZPopOverMenuArrowDirectionDown;
        
        menuArrowPoint.y = menuHeight;
    }
    
    if (menuArrowPoint.x + FTDefaultMenuWidth/2.0 + FTDefaultMargin > KSCREEN_WIDTH) {
        
        menuArrowPoint.x = MIN(menuArrowPoint.x - (KSCREEN_WIDTH - FTDefaultMenuWidth - FTDefaultMargin), FTDefaultMenuWidth - FTDefaultMenuArrowWidth - FTDefaultMargin);
        
        menuX = KSCREEN_WIDTH -FTDefaultMenuWidth - FTDefaultMargin;
        
    }else if (menuArrowPoint.x - FTDefaultMenuWidth/2.0 - FTDefaultMargin < 0){
        
        menuArrowPoint.x = MAX(FTDefaultMenuCornerRadius + FTDefaultMenuArrowWidth, menuArrowPoint.x - FTDefaultMargin);
        
        menuX = FTDefaultMargin;
        
    }else{
    
        menuArrowPoint.x = FTDefaultMenuWidth/2;
        
        menuX = senderRect.origin.x + senderRect.size.width/2.0 - FTDefaultMenuWidth/2.0;
    }

    if (arrowDirection == LZPopOverMenuArrowDirectionUp) {
        
        menuRect = CGRectMake(menuX, senderRect.origin.y+senderRect.size.height,FTDefaultMenuWidth,menuHeight);
        
        if (menuRect.origin.y + menuRect.size.height > KSCREEN_HEIGHT) {
            
            menuRect = CGRectMake(menuX, senderRect.origin.y+senderRect.size.height, FTDefaultMenuWidth, KSCREEN_HEIGHT-menuRect.origin.y-FTDefaultMargin);
            
            shouldAutoScroll = YES;
        }
        
    }else{
        
        menuRect = CGRectMake(menuX, senderRect.origin.y-menuHeight, FTDefaultMenuWidth, menuHeight);
        
        if (menuRect.origin.y < 0) {
            
            menuRect = CGRectMake(menuX, FTDefaultMargin, FTDefaultMenuWidth, senderRect.origin.y - FTDefaultMargin);
            
            menuArrowPoint.y = senderRect.origin.y;
            
            shouldAutoScroll = YES;
        }
    }
    
    self.popMenuView.frame = menuRect;
    self.popMenuView.tintColor = self.tintColor;
    
    [self.popMenuView showWithAnglePoint:menuArrowPoint withNameArray:self.menuArray imageNameArray:self.menuImageArray shouldAutoScroll:shouldAutoScroll arrowDirection:arrowDirection doneBlock:^(NSInteger selectedIndex) {
        
        [self doneActionWithSelectedIndex:selectedIndex];
    }];
    
    [self show];
}

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:FTDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 1;
                     }];
}

-(void)doneActionWithSelectedIndex:(NSInteger)selectedIndex{
    
    [UIView animateWithDuration:FTDefaultAnimationDuration animations:^{
        
        self.popMenuView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.backgroundView removeFromSuperview];
            
            if (selectedIndex<0) {
                
                if (self.dismissBlock) {
                    self.dismissBlock();
                }
            }else{
            
                if (self.doneBlock) {
                    
                    self.doneBlock(selectedIndex);
                }
            }
        }
        
    }];
}

- (void)onBackgroundViewTapped:(UITapGestureRecognizer *)sender{
    
    //隐藏
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)dismiss{
    
    self.isCurrentlyOnScreen = NO;
    
    [self doneActionWithSelectedIndex:-1];
}


@end
