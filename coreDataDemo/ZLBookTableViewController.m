//
//  ZLBookTableViewController.m
//  coreDataDemo
//
//  Created by wdwk on 16/9/27.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import "ZLBookTableViewController.h"
#import "ZLBook.h"
#import "ZLAddBookViewController.h"
@interface ZLBookTableViewController ()<UINavigationControllerDelegate>
@property(nonatomic,strong)AppDelegate * appdelegate;
@property(nonatomic,strong)NSMutableArray *bookArr;

@end

@implementation ZLBookTableViewController
@synthesize appdelegate,bookArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@的图书",self.selectAuthor.name];
    
    appdelegate=[UIApplication sharedApplication].delegate;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        [viewController viewWillAppear:animated];
        [((UITableViewController *) viewController).tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    NSFetchRequest * request=[[NSFetchRequest alloc]init];
    NSEntityDescription * entity=[NSEntityDescription entityForName:@"ZLBook" inManagedObjectContext:appdelegate.managedObjectContext];
    
    [request setEntity:entity];
   
    request.predicate=[NSPredicate predicateWithFormat:@"author=%@", self.selectAuthor];
    //按图书ID排序；
    NSSortDescriptor * sort=[NSSortDescriptor sortDescriptorWithKey:@"bookid" ascending:NO];
    request.sortDescriptors=[NSArray arrayWithObject:sort];
    NSError * error=nil;
    bookArr=[[appdelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if (bookArr==nil) {
        NSLog(@"获取实体失败%@%@",error,[error userInfo]);
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    ZLAddBookViewController * addVC=segue.destinationViewController;
    addVC.selectAuthor=self.selectAuthor;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return bookArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Book" forIndexPath:indexPath];
    
    ZLBook * book=[bookArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text=book.name;
    cell.detailTextLabel.text=book.publishHouse;
    
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (bookArr.count>indexPath.row) {
            ZLBook * book=bookArr[indexPath.row];
            [self deleteBook:book.name];
            [bookArr removeObjectAtIndex:indexPath.row];
        }
        [self.tableView reloadData];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)deleteBook:(NSString * )name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ZLBook"];
    
    //查到到你要删除的数据库中的对象
    NSPredicate *predic = [NSPredicate predicateWithFormat:@"name = %@",name];
    request.predicate = predic;
    
    //请求数据
    NSArray *objs = [appdelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    for (ZLBook *book in objs) {
        [appdelegate.managedObjectContext  deleteObject:book];
    }
    
    
    [appdelegate.managedObjectContext save:nil];
}

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
