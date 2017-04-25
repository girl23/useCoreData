//
//  ZLAddBookViewController.h
//  coreDataDemo
//
//  Created by wdwk on 16/9/27.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAuthor.h"
#import "ZLBook.h"
@interface ZLAddBookViewController : UIViewController
@property(nonatomic,strong)ZLAuthor * selectAuthor;
@property (weak, nonatomic) IBOutlet UITextField *bookidField;

@property (weak, nonatomic) IBOutlet UITextField *booknameField;
@property (weak, nonatomic) IBOutlet UITextField *bookPublishField;
@end
