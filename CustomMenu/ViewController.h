//
//  YLCustomMenu.h
//  CustomeMenu
//
//  Created by Amol Chavan on 24/07/15.
//  Copyright (c) 2015 Yuyutsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenu.h"

@interface ViewController : UIViewController<CustomMenuDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBar;
@property (weak, nonatomic) IBOutlet UILabel *myLable;

- (IBAction)showMenu:(id)sender;

@end

