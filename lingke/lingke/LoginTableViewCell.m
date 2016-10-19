//
//  LoginTableViewCell.m
//  lingke
//
//  Created by clz on 16/8/24.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "LoginTableViewCell.h"


@implementation LoginTableViewCell

- (void)showCellWithEntrySystemBlock:(EntrySystemBlock)entrySystemBlock{
    
    self.entrySystemBlock = entrySystemBlock;
}

- (IBAction)entrySystemAction:(id)sender {
    
    self.entrySystemBlock();
}

@end
