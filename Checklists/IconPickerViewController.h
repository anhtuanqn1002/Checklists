//
//  IconPickerViewController.h
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/9/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>
//method này sử dụng để gán tên icon được chọn
-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak)id <IconPickerViewControllerDelegate> delegate;

@end
