//
//  DataModel.h
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/7/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

-(void)saveChecklist;
-(NSInteger)indexOfSelectedChecklist;
-(void)setIndexOfSelectedChecklist:(NSInteger)index;
-(void)sortChecklists;
+(int)nextChecklistItemId;

@end
