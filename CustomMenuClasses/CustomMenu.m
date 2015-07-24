//
//  CustomMenu.m
//  CustomeMenu
//
//  Created by Amol Chavan on 24/07/15.
//  Copyright (c) 2015 Amol Chavan. All rights reserved.
//

#import "CustomMenu.h"
#import "CustomMenuCell.h"

#define kMenuBackgroundColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95]
#define kContainerBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]
#define kOptionViewMargin 20
#define kTableViewCellHeight 50

@interface CustomMenu()

@property (nonatomic) UIView *targetView;

@property (nonatomic,assign) CGFloat scrollContentHeight;

@property (nonatomic, weak) CustomMenuCell *menuView;
@end

@implementation CustomMenu

- (void)setupInfo
{
    if (_menuBackgroundColor == nil) _menuBackgroundColor = kMenuBackgroundColor;
}

- (void)initialSetupWithMenuOptions
{
    [self setupInfo];
    
    CGFloat showMenuWidth = _targetView.frame.size.width;
    CGFloat showMenuHeight = _targetView.frame.size.height;
    
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //setup container view
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, showMenuWidth, showMenuHeight)];
    [self.containerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]];
    [self.containerView setAlpha:0];
    UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleMenu)];
    tapGuester.delegate = self;
    [self.containerView addGestureRecognizer:tapGuester];
    
    //setup dropMenu
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -showMenuHeight, showMenuWidth, showMenuHeight)];
    _tableView.scrollsToTop = NO;
    [_tableView setBackgroundColor:_menuBackgroundColor];
    [_tableView setHidden:YES];
    
    CGFloat height = kTableViewCellHeight;
    height *= _menuOptionsTitles.count;
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = height;
    self.tableView.frame = tableFrame;
    
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    NSString *qualitiesListCellIdentifier = NSStringFromClass([CustomMenuCell class]);
    UINib *qualitiesHeaderCellNib = [UINib nibWithNibName:qualitiesListCellIdentifier bundle:nil];
    [_tableView registerNib:qualitiesHeaderCellNib forCellReuseIdentifier:qualitiesListCellIdentifier];
    [_tableView reloadData];
}

- (instancetype)initWithTargetView:(UIView*)targetView
{
    self = [super init];
    _status = CustomMenuStatusClose;
    _targetView = targetView;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - toggle,show,hide Menu

- (void)toggleMenu
{
    (! _tableView) ? [self showCustomMenu]:[self hideCustomMenu];
}

- (void)showCustomMenu
{
    
    //setup CustomMenu
    [self initialSetupWithMenuOptions];
    
    // RePosition when Iphone in calling (because statusBar height changed)
    CGSize viewSize = self.view.frame.size;
    CGPoint viewPoint = self.view.frame.origin;
    
    if ([[UIApplication sharedApplication] statusBarFrame].size.height == 40){
        
        [self.view setFrame:CGRectMake(viewPoint.x, -6, viewSize.width, viewSize.height)];
    }else{
        
        [self.view setFrame:CGRectMake(viewPoint.x, 0, viewSize.width, viewSize.height)];
    }
    
    _tableView.hidden = NO;
    
    [_targetView addSubview:self.view];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:_tableView];
    
    _status = CustomMenuStatusShowing;
    if ([self.delegate respondsToSelector:@selector(didChangeStatusWithCustomMenu:)]) {
        [self.delegate didChangeStatusWithCustomMenu:self];
    }
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_tableView setFrame:CGRectMake(kOptionViewMargin, -5, _tableView.frame.size.width-(kOptionViewMargin*2), _tableView.frame.size.height)];
                         [self.containerView setAlpha:0.7];
                     }
                     completion:^(BOOL finished){
                         _status = CustomMenuStatusShow;
                         if ([self.delegate respondsToSelector:@selector(didChangeStatusWithCustomMenu:)]) {
                             [self.delegate didChangeStatusWithCustomMenu:self];
                         }
                         _tableView.scrollsToTop = YES;
                     }];
    
    [UIView commitAnimations];
}

- (void)hideCustomMenu
{
    _status = CustomMenuStatusClosing;
    if ([self.delegate respondsToSelector:@selector(didChangeStatusWithCustomMenu:)]) {
        [self.delegate didChangeStatusWithCustomMenu:self];
    }
    [UIView animateWithDuration:0.3f
                          delay:0.05f
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_tableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, -_tableView.frame.size.height)];
                         [self.containerView setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         _status = CustomMenuStatusClose;
                         if ([self.delegate respondsToSelector:@selector(didChangeStatusWithCustomMenu:)]) {
                             [self.delegate didChangeStatusWithCustomMenu:self];
                         }
                         
                         _tableView.scrollsToTop = NO;
                         [_tableView removeFromSuperview];
                         [self.containerView removeFromSuperview];
                         _tableView = nil;
                         self.containerView = nil;
                         [self.view removeFromSuperview];
                     }];
    [UIView commitAnimations];
}


//-- For no of rows in table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuOptionsTitles.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-- Assign data to cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomMenuCell";
    CustomMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.menuTitle.text = [_menuOptionsTitles objectAtIndex:indexPath.row];
    return cell;
}
//-- Operation when touch cells

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(CustomMenuDidButtonClick:withIndex:)]) {
        [self.delegate CustomMenuDidButtonClick:self withIndex:indexPath.row];
    }
    
    [self toggleMenu];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}
@end
