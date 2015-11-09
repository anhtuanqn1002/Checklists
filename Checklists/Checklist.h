//
//  Checklist.h
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/5/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy)NSString *iconName;

-(int)countUncheckedItems;

@end
