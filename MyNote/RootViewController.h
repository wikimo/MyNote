//
//  RootViewController.h
//  MyNote
//
//  Created by wikimo on 13-12-15.
//  Copyright (c) 2013年 com.wiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddNoteViewController;

@interface RootViewController : UITableViewController

//作用在于在AddNoteViewController中可以直接读取
@property  NSMutableArray *noteArr;

@end
