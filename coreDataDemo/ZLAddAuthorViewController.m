//
//  ZLAddAuthorViewController.m
//  coreDataDemo
//
//  Created by wdwk on 16/9/27.
//  Copyright © 2016年   . All rights reserved.
//

#import "ZLAddAuthorViewController.h"
#import "AppDelegate.h"
#import "ZLAuthor.h"
@interface ZLAddAuthorViewController ()
@property(nonatomic,strong)AppDelegate * appdelegate;
@property(nonatomic,strong) UIAlertView * alert;
@end

@implementation ZLAddAuthorViewController
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
- (IBAction)finishEdior:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)saveAuthor:(id)sender {
    
    if (_nameField.text.length>0&&_descField.text.length>0) {
        //创建一个新的实体对象；
        ZLAuthor * author=[NSEntityDescription  insertNewObjectForEntityForName:@"ZLAuthor" inManagedObjectContext:appdelegate.managedObjectContext];
        //为实体对象设置属性；
        author.name=_nameField.text;
        author.authorDescription=_descField.text;
        //定义一个NSerror对象，用于接收保存错误；
        NSError * error=nil ;
       
        if ([appdelegate.managedObjectContext save:&error]) {
            alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dissmissAlert) withObject:nil afterDelay:2];
        }
        else
        {
            NSLog(@"添加实体失败 %@%@",error,[error userInfo]);
        }
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
