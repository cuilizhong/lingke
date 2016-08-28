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
#import "ExtendappModel.h"


@interface HomepageCell()<UICollectionViewDelegate,UICollectionViewDataSource>

//cell0
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//cell1
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic)NSArray <NewsInfoModel*>* newsInfoModelArray;

@property (strong,nonatomic)NSArray *extendappArray;

@end

@implementation HomepageCell

- (void)awakeFromNib{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomepageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomepageCollectionCellID"];
    
    self.scrollView.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)showCellWithNewsInfoModelArray:(NSArray<NewsInfoModel*>*)newsInfoModelArray extendappArray:(NSArray *)extendappArray{
    
    self.newsInfoModelArray = newsInfoModelArray;
    
    self.extendappArray = extendappArray;
    
    self.scrollView.contentSize = CGSizeMake(newsInfoModelArray.count*self.frame.size.width, self.frame.size.height);
    
    self.pageControl.numberOfPages = newsInfoModelArray.count;
    
    self.pageControl.hidden = newsInfoModelArray.count>0?NO:YES;
    
    for (int i = 0; i<newsInfoModelArray.count; i++) {
        
        NewsInfoModel *newsInfoModel = newsInfoModelArray[i];
        
        NSString *title = newsInfoModel.title;
        
        NSString *img = newsInfoModel.img;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        
        imageView.userInteractionEnabled = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@" "] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.frame.size.height-20, imageView.frame.size.width-20, 20)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        NSLog(@"titlelabel.frame.x = %f",titleLabel.frame.origin.x);
        
        [imageView addSubview:titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        
        
        [self.scrollView addSubview:imageView];

        
    }
    
    [self.collectionView reloadData];

}

- (void)tap:(UITapGestureRecognizer*)sender{
    
    NSLog(@"点击");
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
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor greenColor]];
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
    
}


@end
