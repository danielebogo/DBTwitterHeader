//
//  DBTwitterHeaderViewController.m
//  dbtwitterheader
//
//  Created by Daniele Bogo on 28/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "DBTwitterHeaderViewController.h"

#import "DBTwitterHeaderTableViewDataSource.h"


static const CGFloat kDBTwitterHeaderHeight = 110.0;

CGFloat const offset_HeaderStop = 40.0;
CGFloat const offset_B_LabelHeader = 95.0;
CGFloat const distance_W_LabelHeader = 35.0;


@interface DBTwitterHeaderViewController () <UIScrollViewDelegate, UITableViewDelegate>

@end


@implementation DBTwitterHeaderViewController {
    DBTwitterHeaderTableViewDataSource *datasource_;
    UITableView *tableView_;
    UIView *headerView_;
    UIView *tableHeaderView_;
    UIView *userContainer_;
    UIImageView *avatarImage_;
    UIImageView *headerImageView_;
    UILabel *headerLabel_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datasource_ = [DBTwitterHeaderTableViewDataSource new];
    
    [self dbt_buildUI];
    [self dbt_addConstraints];
}


#pragma mark - Private methods

- (void)dbt_buildUI
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, CGRectGetWidth(self.view.frame), kDBTwitterHeaderHeight + 100.0 }];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    userContainer_ = [UIView new];
    userContainer_.translatesAutoresizingMaskIntoConstraints = NO;
    [tableHeaderView addSubview:userContainer_];
    
    headerView_ = [UIView new];
    headerView_.translatesAutoresizingMaskIntoConstraints = NO;
    headerView_.clipsToBounds = YES;
    [self.view addSubview:headerView_];
    
    headerImageView_ = [UIImageView new];
    headerImageView_.translatesAutoresizingMaskIntoConstraints = NO;
    headerImageView_.backgroundColor = [UIColor redColor];
    [headerView_ addSubview:headerImageView_];
    
    headerLabel_ = [UILabel new];
    headerLabel_.translatesAutoresizingMaskIntoConstraints = NO;
    headerLabel_.textAlignment = NSTextAlignmentCenter;
    headerLabel_.text = @"Title";
    [headerView_ addSubview:headerLabel_];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView_.translatesAutoresizingMaskIntoConstraints = NO;
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.backgroundView = nil;
    tableView_.dataSource = datasource_;
    tableView_.delegate = self;
    tableView_.tableHeaderView = tableHeaderView;
    [self.view addSubview:tableView_];
    
    avatarImage_ = [UIImageView new];
//    avatarImage_.image = avatarImage;
    avatarImage_.translatesAutoresizingMaskIntoConstraints = NO;
    avatarImage_.layer.cornerRadius = 35;
    avatarImage_.layer.borderWidth = 3;
    avatarImage_.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImage_.backgroundColor = [UIColor blackColor];
    avatarImage_.clipsToBounds = YES;
    [userContainer_ addSubview:avatarImage_];
}


- (void)dbt_addConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(headerView_, headerImageView_, headerLabel_, tableView_, userContainer_, avatarImage_);
    NSDictionary *metrics = @{ @"headerH":@(kDBTwitterHeaderHeight) };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView_]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView_(headerH)]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView_]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView_]|" options:0 metrics:nil views:views]];

    [headerView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerImageView_]|" options:0 metrics:nil views:views]];
    [headerView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerImageView_]|" options:0 metrics:nil views:views]];

    [headerView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerLabel_]|" options:0 metrics:nil views:views]];
    [headerView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-headerH-[headerLabel_]" options:0 metrics:metrics views:views]];
    
    [tableView_.tableHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userContainer_]|" options:0 metrics:nil views:views]];
    [tableView_.tableHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userContainer_]|" options:0 metrics:nil views:views]];

    [userContainer_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[avatarImage_(70)]" options:0 metrics:nil views:views]];
    [userContainer_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[avatarImage_(70)]" options:0 metrics:nil views:views]];
    [userContainer_ addConstraint:[NSLayoutConstraint constraintWithItem:avatarImage_ attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:userContainer_ attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}


- (void)dbt_animationForOffset:(CGFloat)offset
{
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D avatarTransform = CATransform3DIdentity;
    
    // DOWN -----------------
    
    if (offset < 0) {
        CGFloat headerScaleFactor = -(offset) / headerView_.bounds.size.height;
        CGFloat headerSizevariation = ((headerView_.bounds.size.height * (1.0 + headerScaleFactor)) - headerView_.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        headerView_.layer.transform = headerTransform;
        
        if (offset < -self.view.frame.size.height/3.5) {
//            [self recievedMBTwitterScrollEvent];
        }
        
    }
    
    // SCROLL UP/DOWN ------------
    
    else {
        
        // Header -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
        headerLabel_.layer.transform = labelTransform;
        headerLabel_.layer.zPosition = 2;
        
        // Avatar -----------
        CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offset)) / avatarImage_.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((avatarImage_.bounds.size.height * (1.0 + avatarScaleFactor)) - avatarImage_.bounds.size.height) / 2.0;
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
//
        if (offset <= offset_HeaderStop) {
            if (avatarImage_.layer.zPosition <= headerView_.layer.zPosition) {
                headerView_.layer.zPosition = 0;
            }
        }else {
            if (avatarImage_.layer.zPosition >= headerView_.layer.zPosition) {
                headerView_.layer.zPosition = 2;
            }
        }
        
    }
    
//    if (self.headerImageView.image != nil) {
//        [self blurWithOffset:offset];
//    }
//    
    headerView_.layer.transform = headerTransform;
    avatarImage_.layer.transform = avatarTransform;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    [self dbt_animationForOffset:offset];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offset = tableView_.contentOffset.y;
    [self dbt_animationForOffset:offset];
}


@end