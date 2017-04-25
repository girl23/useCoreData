//
//  ZLAuthorListController.m
//  coreDataDemo
//
//  Created by wdwk on 16/9/27.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import "ZLAuthorListController.h"
#import "AppDelegate.h"
#import "ZLAuthor.h"
#import "ZLBook.h"
#import "ZLBookTableViewController.h"

@interface ZLAuthorListController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)AppDelegate * appDelegate;
@property(nonatomic,strong)NSMutableArray * authorArr;
@end

@implementation ZLAuthorListController
@synthesize appDelegate,authorArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate=self;
    appDelegate=[[UIApplication sharedApplication] delegate];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
   [self AddData];

}
-(void)viewWillAppear:(BOOL)animated
{
    //默认加载两条数据
   authorArr= [self selectData];
}
//插入数据：默认生成两条数据；
-(void)AddData
{
    //设置两位作者
    ZLAuthor * author=[NSEntityDescription  insertNewObjectForEntityForName:@"ZLAuthor" inManagedObjectContext:appDelegate.managedObjectContext];
    //为实体对象设置属性；
    author.name=[NSString stringWithFormat:@"小周%d",1];
    author.authorDescription=[NSString stringWithFormat:@"小说类作家%d",1];
  
    ZLAuthor * author2=[NSEntityDescription  insertNewObjectForEntityForName:@"ZLAuthor" inManagedObjectContext:appDelegate.managedObjectContext];
    author2.name=[NSString stringWithFormat:@"小李%d",1];
    author2.authorDescription=[NSString stringWithFormat:@"影视类作家%d",1];
 

    //设置书本
    ZLBook *book = [NSEntityDescription insertNewObjectForEntityForName:@"ZLBook" inManagedObjectContext:appDelegate.managedObjectContext];
    book.bookid=@"0000";
    book.name = @"<大海>";
    book.publishHouse=@"北京出版社" ;
    
    ZLBook *book1 = [NSEntityDescription insertNewObjectForEntityForName:@"ZLBook" inManagedObjectContext:appDelegate.managedObjectContext];
     book1.bookid=@"0001";
    book1.name = @"<海2>";
    book1.publishHouse=@"北京出版社" ;
    
    ZLBook *book2 = [NSEntityDescription insertNewObjectForEntityForName:@"ZLBook" inManagedObjectContext:appDelegate.managedObjectContext];
    book2.bookid=@"0002";
    book2.name = @"<神犬小七>";
    book2.publishHouse=@"影视出版社" ;
    
    //设置作者与书本的关联关系；
    [author addBooks:[NSSet setWithObjects:book,book1,nil]];
    [author2 addBooks:[NSSet setWithObjects:book2, nil]];
    
    //定义一个NSerror对象，用于接收保存错误；
    NSError * error=nil ;
    if ([appDelegate.managedObjectContext save:&error]) {
        NSLog(@"添加实体成功%d",1) ;
    }
    else
    {
        NSLog(@"添加实体失败 %@%@",error,[error userInfo]);
    }
    
}
//查询所有，获取数据：
-(NSMutableArray *)selectData
{
    NSFetchRequest * request=[[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity=[NSEntityDescription entityForName:@"ZLAuthor" inManagedObjectContext:[self managedObjectContext]];
    
    [request setEntity:entity];
    [request setFetchBatchSize:2];
    [request setFetchLimit:10];//限定查询的数量；
    [request setFetchOffset:0];//查询的偏移量,从第几个数据开始查询
    [request setIncludesPropertyValues:NO];
    NSError * error=nil;
    //通过查询将本地数据添加到数组中,查询全部数据；
    NSMutableArray *  tempArr=[[appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if (tempArr==nil) {
        NSLog(@"获取实体失败%@%@",error,[error userInfo]);
        return nil;
    }
    return tempArr;

}
//根据条件查询数据；查询结果是固定不变的所以用NSArray;
-(NSArray * )selectDataWithName:(NSString *)Name;
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@",Name];
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ZLAuthor" inManagedObjectContext:context]];
    [request setPredicate:predicate];
    //这里相当于sqlite中的查询条件，具体格式参考苹果文档 //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    return result;
}
- (IBAction)mendData:(id)sender {
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"请输要更改作者例如“小李1=小七”"message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField * field=[alertView textFieldAtIndex:0];
    
    if((![field.text containsString:@"="])||field.text==nil||[field.text isEqualToString:@""])
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"格式有误"message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
     NSArray * tempArr=[field.text componentsSeparatedByString:@"="];
     [self updateData:tempArr[0] withNewName:tempArr[1]];
}
//更新
- (void)updateData:(NSString*)oldName withNewName:(NSString*)NewName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray * result=[self selectDataWithName:oldName];
    NSError *error = nil;
    for (ZLAuthor *info in result)
    {
        info.name=NewName;
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
        //修改成功后重新刷新数据；
        [authorArr removeAllObjects];
        authorArr=[self selectData];
        [self.tableView reloadData];
    }
}

#pragma mark - Core Data stack
//返回管理上下文
- (NSManagedObjectContext *)managedObjectContext
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

 //当导航视图控制控制某个视图控制器显示出来时，该方法自动调用，如果控制器时UITableViewController子类的实例，程序将重新执行查询，并让tableView重新加载数据
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[UITableViewController class]]) {
       
        [viewController viewWillAppear:animated];
        
        [((UITableViewController*)viewController).tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return authorArr.count;
}
- (IBAction)ZLdelete:(id)sender {
    //删除全部
    //先获取本地储存的所有数据
    NSMutableArray * deleteArr=[self selectData];
    
    for (int i=0; i<deleteArr.count; i++) {
        ZLAuthor * author=deleteArr[i];
        [appDelegate.managedObjectContext deleteObject:author ];
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            NSLog(@"删除实体失败%@%@",error,[error userInfo]);
        }
        [authorArr removeObject:author];
        [self.tableView reloadData];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Author" forIndexPath:indexPath];
    
    ZLAuthor * author=[authorArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text=author.name;
    cell.detailTextLabel.text=author.authorDescription;
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isMemberOfClass:[ZLBookTableViewController class]]) {
        UITableViewCell* cell=(UITableViewCell * )sender;
        NSIndexPath * indexpath=[self.tableView indexPathForCell:cell];
        ZLBookTableViewController * booKlistController=(ZLBookTableViewController*)segue.destinationViewController;
        booKlistController.selectAuthor=[authorArr objectAtIndex:indexpath.row];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
