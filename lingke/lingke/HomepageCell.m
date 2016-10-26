//
//  HomepageCell.m
//  lingke
//
//  Created by clz on 16/8/28.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "HomepageCell.h"
#import "HomepageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewInfoImageView.h"
#import "ConfigureColor.h"




@interface HomepageCell()<UICollectionViewDelegate,UICollectionViewDataSource>

//cell0
@property(nonatomic,strong)UIScrollView *scrollView;

@property (strong, nonatomic)UIPageControl *pageControl;

@property (strong, nonatomic)NSTimer *timer;

//cell1
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@property (strong,nonatomic)NSArray <NewsInfoModel*>* newsInfoModelArray;

@property (strong,nonatomic)NSArray <ExtendappModel*>* extendappArray;

@property (strong,nonatomic)JumpNewsinfoBlock jumpNewsinfoBlock;

@property (strong,nonatomic)EnterExtendappBlock enterExtendappBlock;



@end

@implementation HomepageCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomepageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomepageCollectionCellID"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    
    self.scrollView.delegate = self;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    
    [self.timer setFireDate:[NSDate distantFuture]];

}

- (void)timer:(NSTimer *)sender{
    
    CGPoint point = self.scrollView.contentOffset;
    
    CGFloat offsetX = self.scrollView.frame.size.width+point.x;
    
    if (offsetX >= self.scrollView.frame.size.width * self.newsInfoModelArray.count) {
        
        offsetX = 0;
    }
    point.x = offsetX;
    
    self.scrollView.contentOffset = point;
    
    //设置循环滚动
    NSInteger page = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    [self.pageControl setCurrentPage:page];
    
}

- (void)showCellWithNewsInfoModelArray:(NSArray<NewsInfoModel*>*)newsInfoModelArray cellSize:(CGSize)cellSize cellIndex:(NSInteger)cellIndex extendappArray:(NSArray *)extendappArray jumpNewsinfoBlock:(JumpNewsinfoBlock)jumpNewsinfoBlock enterExtendappBlock:(EnterExtendappBlock)enterExtendappBlock{
    
    self.newsInfoModelArray = newsInfoModelArray;
    
    self.extendappArray = extendappArray;
    
    if (cellIndex == 0) {
        
        if (!self.scrollView) {
            
            self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
            
            self.scrollView.delegate = self;
            
            self.scrollView.pagingEnabled = YES;
            
            self.scrollView.bounces = NO;
            
            self.scrollView.showsVerticalScrollIndicator = NO;
            self.scrollView.showsHorizontalScrollIndicator = NO;
            
            [self addSubview:self.scrollView];
            
            self.scrollView.contentSize = CGSizeMake(newsInfoModelArray.count*cellSize.width, cellSize.height);
        }
        
        if (!self.pageControl) {
            
            self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(cellSize.width - cellSize.width/3.0,cellSize.height-37, cellSize.width/3.0 - 15, 37)];
            self.pageControl.tintColor = [UIColor darkGrayColor];
            self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            
            [self addSubview:self.pageControl];
        }
        
        
        self.pageControl.numberOfPages = newsInfoModelArray.count;
        
        self.pageControl.hidden = newsInfoModelArray.count>0?NO:YES;
        
        for (int i = 0; i<newsInfoModelArray.count; i++) {
            
            NewsInfoModel *newsInfoModel = newsInfoModelArray[i];
            
            NSString *title = newsInfoModel.title;
            
            NSString *img = newsInfoModel.img;
            
            NewInfoImageView *imageView = [[NewInfoImageView alloc]initWithFrame:CGRectMake(i*cellSize.width, 0, cellSize.width, cellSize.height)];
            
            imageView.userInteractionEnabled = YES;
            
            imageView.newsInfoModel = newsInfoModel;
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
            UIView *labelBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-40, cellSize.width, 40)];
            labelBackgroundView.backgroundColor = [ConfigureColor sharedInstance].middleBlue;
            [imageView addSubview:labelBackgroundView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,10, cellSize.width/3.0*2, 20)];
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [labelBackgroundView addSubview:titleLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
            
            
            [self.scrollView addSubview:imageView];
            
        }
        
        if (newsInfoModelArray.count>1) {
            
            [self.timer setFireDate:[NSDate distantPast]];
            [self.timer fire];
        }
        
    }
    
    self.jumpNewsinfoBlock = jumpNewsinfoBlock;
    
    self.enterExtendappBlock = enterExtendappBlock;
    
    [self.collectionView reloadData];

}

- (void)tap:(UITapGestureRecognizer*)sender{
    
    NSLog(@"点击");
    NewInfoImageView *view = (NewInfoImageView *)sender.view;
    
    self.jumpNewsinfoBlock(view.newsInfoModel);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    self.pageControl.currentPage = page;
}


#pragma mark-UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.extendappArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用cell
    HomepageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomepageCollectionCellID" forIndexPath:indexPath];
        
    //赋值
    ExtendappModel *extendappModel = self.extendappArray[indexPath.row];
    
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:extendappModel.applogo] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    cell.nameLabel.text = extendappModel.appname;
    
    return cell;
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.frame.size.width/3.0,self.frame.size.width/3.0);
    
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0,0);//分别为上、左、下、右
    
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   return 0;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
    
    ExtendappModel *extendappModel = self.extendappArray[indexPath.row];
    
    self.enterExtendappBlock(extendappModel);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}



////取消选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
//    
//}


@end
