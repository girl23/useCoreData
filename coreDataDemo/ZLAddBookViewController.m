//
//  ZLAddBookViewController.m
//  coreDataDemo
//
//  Created by wdwk on 16/9/27.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import "ZLAddBookViewController.h"
#import "AppDelegate.h"
@interface ZLAddBookViewController ()
@property(nonatomic,strong)AppDelegate * appdelegate;
@property(nonatomic,strong)UIAlertView *alert;
@end

@implementation ZLAddBookViewController
@synthesize appdelegate,alert;
- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate=[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBook:(id)sender {
    //查询是否有数据，有数据则不能添加成功；
    
    
    ZLBook * book=[NSEntityDescription insertNewObjectForEntityForName:@"ZLBook" inManagedObjectContext:appdelegate.managedObjectContext];
    book.bookid=_bookidField.text;
    book.name=_booknameField.text;
    book.publishHouse=_bookPublishField.text;
    [_selectAuthor addBooksObject:book];
    
    NSError * error;
    if (![appdelegate.managedObjectContext save:&error]) {
        NSLog(@"添加书本到该作者失败%@%@",error,[error userInfo]);
    }
    else
    {
        alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dissmissAlert) withObject:nil afterDelay:2];
        
    }
}
-(void)dissmissAlert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
