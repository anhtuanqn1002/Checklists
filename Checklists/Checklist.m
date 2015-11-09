//
//  Checklist.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/5/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"

@implementation Checklist

//dinh nghia lai init
-(id)init {
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
        self.iconName = @"No Icon";
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName =[aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

-(int)countUncheckedItems {
    int count = 0;
    for (ChecklistItem *item in self.items) {
        if (!item.checked ) {
            count += 1;
        }
    }
    return count;
}

-(NSComparisonResult)compare:(Checklist *)otherChecklist {
    return [self.name localizedStandardCompare:otherChecklist.name];
}
@end
