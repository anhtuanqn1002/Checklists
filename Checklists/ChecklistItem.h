//
//  ChecklistItem.h
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChecklistItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, assign) BOOL shouldRemind;
@property (nonatomic, assign) NSInteger itemId;
-(void)toggleChecked;


@end
