//
//  ChecklistItem.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//
#import <UIKit/UIKit.h>
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
-(UILocalNotification *)notificationForThisItem {
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && [number integerValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}
-(void)scheduleNotification {
    //method notificationForThisItem giúp lấy ra cái notification tương ứng với item được chọn
    //nếu như lấy được, tức là có dữ liệu thì tiến hành huỷ notification hiện tại.
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemID": @(self.itemId)};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSLog(@"Scheduled notification %@ for itemId %ld", localNotification, (long)self.itemId);
    }
}

-(void)dealloc {
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Removing existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}
@end
