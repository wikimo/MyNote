//
//  DetailViewController.m
//  MyNote
//
//  Created by wikimo on 13-12-16.
//  Copyright (c) 2013年 com.wiki. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property UITextView *contentTxtView;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *noteArr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    
    
    UIBarButtonItem *updateBtn = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStyleBordered target:self action:@selector(updateNote)];
    self.navigationItem.rightBarButtonItem = updateBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTxtView = [[UITextView alloc]initWithFrame:
                           CGRectMake(5,5,
                                      self.view.bounds.size.width - 10,
                                      self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 10)];
    self.contentTxtView.font = [UIFont boldSystemFontOfSize:16];
    self.contentTxtView.text = [noteArr objectAtIndex:self.index];

    [self.view addSubview:self.contentTxtView];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新笔记
//思路：将原有的笔记删除，重新插入一个
- (void) updateNote{
    NSArray *tempNoteArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSMutableArray *noteArr = [tempNoteArr mutableCopy];
    
    [noteArr removeObjectAtIndex:self.index];
    [noteArr insertObject:self.contentTxtView.text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:noteArr forKey:@"note"];
    
    
    [self.contentTxtView resignFirstResponder];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"更新成功！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}


@end
