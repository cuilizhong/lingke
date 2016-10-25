//
//  SearchExtendAppSubChooseDateView.m
//  lingke
//
//  Created by clz on 16/10/25.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "SearchExtendAppSubChooseDateView.h"


@interface SearchExtendAppSubChooseDateView()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong,nonatomic)DoneBlock doneBlock;


@end

@implementation SearchExtendAppSubChooseDateView


- (void)showViewWithDoneBlock:(DoneBlock)doneBlock{
    
    self.doneBlock = doneBlock;
}

- (IBAction)doneAction:(id)sender {
    
    NSDate *select = [self.datePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr =  [dateFormatter stringFromDate:select];
    
    self.doneBlock(dateStr);
    
    [self removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    
    [self removeFromSuperview];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}
@end
