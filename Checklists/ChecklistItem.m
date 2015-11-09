//
//  ChecklistItem.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

-(void)toggleChecked {
    self.checked = !self.checked;
}

-(id)init {
    if (self = [super init]) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}

//implemented phương thức encodeWithCoder để cho phương thức saveChecklistItems biết đang làm việc với thằng nào
//tham số forKey để cho đối tượng aCoder hiểu (ví dụ như self.text là của @"Text") để phục vụ việc đọc ghi dữ liệu sau này
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self;
}
@end
