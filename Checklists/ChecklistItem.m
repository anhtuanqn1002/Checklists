//
//  ChecklistItem.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ChecklistItem.h"


@implementation ChecklistItem

-(void)toggleChecked {
    self.checked = !self.checked;
}

//implemented phương thức encodeWithCoder để cho phương thức saveChecklistItems biết đang làm việc với thằng nào
//tham số forKey để cho đối tượng aCoder hiểu (ví dụ như self.text là của @"Text") để phục vụ việc đọc ghi dữ liệu sau này
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    }
    return self;
}
@end
