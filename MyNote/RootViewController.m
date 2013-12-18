//
//  RootViewController.m
//  笔记列表Controller，根Controller
//
//  Created by wikimo on 13-12-15.
//  Copyright (c) 2013年 com.wiki. All rights reserved.
//

#import "RootViewController.h"
#import "AddNoteViewController.h"
#import "DetailViewController.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>

@property NSMutableArray *filterNoteArr; //检索存储数组
@property UISearchBar *bar;
@property UISearchDisplayController *searchDispCtrl;

@end

@implementation RootViewController
@synthesize noteArr,filterNoteArr,bar,searchDispCtrl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //返回值并不是一个NSMutableArray类型，所以需要转换下，否则removeObjectAtIndex没办法调用
    NSArray *tempArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    self.noteArr = [tempArr mutableCopy];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //创建添加按钮
    UIBarButtonItem *addBtn =  [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(toAddNote)];
    
    self.navigationItem.rightBarButtonItem = addBtn;
    
    //创建搜索框
    bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    
    searchDispCtrl = [[UISearchDisplayController alloc]initWithSearchBar:bar contentsController:self];
    searchDispCtrl.delegate = self;
    searchDispCtrl.searchResultsDelegate = self;
    searchDispCtrl.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = bar;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //指定sections的数量，必须有返回值，否则cellForRowAtIndexPath不能调用，我们这里只有1个note列表，所以返回1；
    return 1;
}

//指定当前section中返回记录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断是否通过检索的方式
    if (tableView == self.searchDispCtrl.searchResultsTableView) {
        return [filterNoteArr count];
    }
    return [noteArr count];
}

//进行数据表填充
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //指定cell右边的图标样式；
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *note = nil;
    if (tableView ==  self.searchDispCtrl.searchResultsTableView) {
        note = [filterNoteArr objectAtIndex:indexPath.row];
    } else {
        note = [noteArr objectAtIndex:indexPath.row];
    }
    
    //对标题字符串长度做修饰
    NSInteger titleLen =  [note length];
    if (titleLen < 22) {
        cell.textLabel.text =  note;
    } else {
        cell.textLabel.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //获取当前删除项在noteArr中对应的实际索引
        NSInteger index = 0;
        if (tableView == self.searchDispCtrl.searchResultsTableView) {
            index =  [self getNoteIndex:noteArr ByFilterArr:filterNoteArr AndFilterIndex:indexPath.row];
            [filterNoteArr removeObjectAtIndex:indexPath.row];
        } else {
            index =  indexPath.row;
        }

        //更新noteArr
        [self.noteArr removeObjectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:self.noteArr forKey:@"note"];
        
        //刷新当前的tableView，可能是普通的tableView也可能是searchResultsTableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //当通过检索方式删除时，刷新原有的tableView，如果是默认状态下，通过上述代码已实现刷新列表效果
        if (tableView == self.searchDispCtrl.searchResultsTableView){
            [self.tableView reloadData];
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailCtrl =  [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    NSInteger index =  indexPath.row;
    
    if (tableView == self.searchDispCtrl.searchResultsTableView) {
        //通过检索的方式获取fiterNoteArr中选中项在noteArr中对应的实际索引
        detailCtrl.index = [self getNoteIndex:noteArr ByFilterArr:filterNoteArr AndFilterIndex:index];
    
    } else {
        detailCtrl.index = [indexPath row];
    }
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}


//添加笔记
- (void) toAddNote{
    //创建添加笔记controller
    AddNoteViewController *addNoteViewController = [[AddNoteViewController alloc]initWithNibName:nil bundle:nil];
    
    //设置back按钮的title
    UIBarButtonItem *backBtn =  [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController pushViewController:addNoteViewController animated:YES];
}

//默认必须要实现的检索方法
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [filterNoteArr removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",
                              searchString];
    NSArray *tmpArr = [noteArr filteredArrayUsingPredicate:
                       predicate];
    filterNoteArr = [NSMutableArray arrayWithArray:tmpArr];
    
    return YES;
}

//在检索时通过filterArr获取在noteArray实际的索引值
//实际就是遍历比对得结果，思路很简单
- (NSInteger) getNoteIndex:(NSMutableArray *)noteArray
    ByFilterArr:(NSMutableArray *)filterArr
    AndFilterIndex:(NSInteger) index{
    
    NSString *noteContent = [filterArr objectAtIndex:index];
    NSInteger i = 0;

    for (NSString *tmpContent in noteArray) {
        if (tmpContent == noteContent) {
            return i;
        }
        i++;
    }
    
    return 0;
}

@end
