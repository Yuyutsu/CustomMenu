//
//  CustomMenu.h
//  CustomeMenu
//
//  Created by Amol Chavan on 24/07/15.
//  Copyright (c) 2015 Amol Chavan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomMenuStatus) {
    CustomMenuStatusClose,
    CustomMenuStatusClosing,
    CustomMenuStatusShow,
    CustomMenuStatusShowing
};

@class CustomMenu;

@protocol CustomMenuDelegate <NSObject>

@required
- (void)CustomMenuDidButtonClick:(CustomMenu*)dropMenu withIndex:(NSInteger)index;

@optional
- (void)didChangeStatusWithCustomMenu:(CustomMenu*)dropMenu;
@end

@interface CustomMenu : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic,assign) CustomMenuStatus status;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIColor *menuBackgroundColor;

//
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) NSInteger selectSubIndex;

@property (nonatomic,weak) id <CustomMenuDelegate> delegate;

//menu options
@property (nonatomic,strong) NSMutableArray* menuOptionsTitles;

- (id)initWithTargetView:(UIView*)targetView;
- (void)toggleMenu;
- (void)showCustomMenu;
- (void)hideCustomMenu;

@end
