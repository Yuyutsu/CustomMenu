//
//  CustomMenu.h
//  SampleMenu
//
//  Created by Amol Chavan on 24/07/15.
//  Copyright (c) 2015 LiveSimply. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CustomMenu *menu;
@property (nonatomic) UIView *menuContainerView;
@property (nonatomic) NSMutableArray *options;

@property (nonatomic) NSString *nowSelect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // Do any additional setup after loading the view, typically from a nib.
    _options = [NSMutableArray arrayWithArray:@[@"One",@"Two",@"Three",@"Four"]];

    [self CustomMenuSetup];
    
}

#pragma mark - CustomMenu

- (void)CustomMenuSetup
{    
    
    _menuContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 0)];
    _menuContainerView.backgroundColor = [UIColor clearColor];
    _menuContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _menuContainerView.layer.cornerRadius = 10;
    [self.view addSubview:_menuContainerView];
    _menuContainerView.hidden = YES;
    
    _menu = [[CustomMenu alloc] initWithTargetView:_menuContainerView];
    _menu.delegate = self;
    _menu.menuOptionsTitles = _options;
}

- (void)toggleMainMenu
{
    [_menu toggleMenu];
}


#pragma mark CustomMenu Delegate

- (void)didChangeStatusWithCustomMenu:(CustomMenu *)dropMenu
{
    if (dropMenu == _menu) {
        if (dropMenu.status == CustomMenuStatusShowing) {
            _menuContainerView.hidden = NO;
        }else if (dropMenu.status == CustomMenuStatusClose){
            _menuContainerView.hidden = YES;
        }
    }
}

- (void)CustomMenuDidButtonClick:(CustomMenu *)dropMenu withIndex:(NSInteger)index{
    NSLog(@"option clicked:=>    %ld",(long)index);
    _myLable.text = [_options objectAtIndex:index];
}


- (IBAction)showMenu:(id)sender {
    [self toggleMainMenu];
}
@end
