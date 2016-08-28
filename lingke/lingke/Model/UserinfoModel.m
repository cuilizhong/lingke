//
//  UserinfoModel.m
//  lingke
//
//  Created by clz on 16/8/26.
//  Copyright © 2016年 CLZ. All rights reserved.
//

#import "UserinfoModel.h"


static UserinfoModel *userinfoModel = nil;


@implementation UserinfoModel

+(instancetype )sharedInstance{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        userinfoModel = [[self alloc] init];
        
    });
    
    return userinfoModel;
}

- (void)setValueFromResponsedataEle:(GDataXMLElement *)responsedataEle{
    
    GDataXMLElement *appcenterEle = [[responsedataEle elementsForName:@"appcenter"] lastObject];
    
    GDataXMLElement *uriEle = [[appcenterEle elementsForName:@"uri"]lastObject];
    
    self.uri = uriEle.stringValue;
    
    GDataXMLElement *personinfoEle = [[responsedataEle elementsForName:@"personinfo"]lastObject];
    
    GDataXMLElement *genderEle = [[personinfoEle elementsForName:@"gender"]lastObject];
    
    GDataXMLElement *mobileEle = [[personinfoEle elementsForName:@"mobile"]lastObject];
    
    GDataXMLElement *usernameEle = [[personinfoEle elementsForName:@"username"]lastObject];
    
    GDataXMLElement *headurlEle = [[personinfoEle elementsForName:@"headurl"]lastObject];

    self.gender = genderEle.stringValue;
    
    self.mobile = mobileEle.stringValue;
    
    self.username = usernameEle.stringValue;
    
    self.headurl = headurlEle.stringValue;
    
    GDataXMLElement *sessioninfoEle = [[responsedataEle elementsForName:@"sessioninfo"]lastObject];

    GDataXMLElement *expiresinEle = [[sessioninfoEle elementsForName:@"expiresin"]lastObject];
    
    GDataXMLElement *tokenEle = [[sessioninfoEle elementsForName:@"token"]lastObject];

    self.expiresin = expiresinEle.stringValue;
    
    self.token = tokenEle.stringValue;
    
    
    
    GDataXMLElement *unitinfoEle = [[responsedataEle elementsForName:@"unitinfo"]lastObject];

    GDataXMLElement *customerlogoEle = [[unitinfoEle elementsForName:@"customerlogo"]lastObject];
    
    GDataXMLElement *unitcodeEle = [[unitinfoEle elementsForName:@"unitcode"]lastObject];
    
    GDataXMLElement *unitnameEle = [[unitinfoEle elementsForName:@"unitname"]lastObject];
    
    GDataXMLElement *updatetimeEle = [[unitinfoEle elementsForName:@"updatetime"]lastObject];


    self.customerlogo = customerlogoEle.stringValue;
    
    self.unitcode = unitcodeEle.stringValue;
    
    self.unitname = unitnameEle.stringValue;
    
    self.updatetime = updatetimeEle.stringValue;
   
}


@end
