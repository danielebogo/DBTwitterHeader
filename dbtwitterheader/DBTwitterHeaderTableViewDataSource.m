//
//  DBTwitterHeaderTableViewDataSource.m
//  dbtwitterheader
//
//  Created by Daniele Bogo on 28/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "DBTwitterHeaderTableViewDataSource.h"


@interface DBTwitterHeaderTableViewDataSource ()

@end

@implementation DBTwitterHeaderTableViewDataSource


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempString = @"kTempString";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempString];
    }
    
    return cell;
}

@end