//
//  AddNoteViewController.m
//  添加笔记Controller
//
//  Created by wikimo on 13-12-13.
//  Copyright (c) 2013年 com.wiki. All rights reserved.
//

#import "AddNoteViewController.h"
#import "RootViewController.h"

@interface AddNoteViewController ()

//私有，别的类不需要访问
@property UITextView *contentTxtView;

@end

@implementation AddNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化添加页面
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIBarButtonItem *savtBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveNote)];
    self.navigationItem.rightBarButtonItem = savtBtn;
    
    
    //这里主要为了设置UITextView的边距空隙
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTxtView = [[UITextView alloc]initWithFrame:
                           CGRectMake(5,5,
                                      self.view.bounds.size.width - 10,
                                      self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 10)];
    //设置字体大小
    self.contentTxtView.font = [UIFont boldSystemFontOfSize:16];
    
    //弹出输入键盘
    [self.contentTxtView becomeFirstResponder];

    [self.view addSubview:self.contentTxtView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存笔记
//关于数据的存储其实是通过NSUserDefaults对象的setObject去设置一个数组实现的；
//然后就是读写这个数组，而不通过数据库实现；
- (void) saveNote{
    //对@note对象做初始化，否则可能写不进数据
    NSMutableArray *initNoteArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"note"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initNoteArray forKey:@"note"];
    }
    
    //读取笔记记录
    NSArray *tempNoteArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    //复制tempNoteArr内容至noteArr，因为NSMutableArray长度是可变的,NSArray不可变；
    NSMutableArray *noteArr = [tempNoteArr mutableCopy];
    
    //保存笔记记录
    [noteArr insertObject:self.contentTxtView.text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:noteArr forKey:@"note"];
    
    //关闭输入键盘
    [self.contentTxtView resignFirstResponder];
    
    //创建提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"保存成功！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
