//
//  itemDetailViewController.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"
@implementation ItemDetailViewController
{
    NSDate *_dueDate;
}
//method này có tác dụng cập nhật giá trị dueDateLabel
- (void)updateDueDateLable {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"chay vao additem");
    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
        //NSLog(@"chay vao edit item");
        
        //set giá trị cho switchControl = giá trị shouldRemind
        //nếu là add thì ta gán switchControl = NO;
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    } else {
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    [self updateDueDateLable];
}

#pragma mark - Table view data source

-(IBAction)cancel {
    [self.delegate itemDetailViewControllerDidCancel:self];
}

-(IBAction)done{
    if (self.itemToEdit == nil) {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        
        item.shouldRemind = self.switchControl.on;
        item.dueDate = _dueDate;
        
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    } else {
        self.itemToEdit.text = self.textField.text;
        
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
}

//selected vao 1 row se khong xay ra dieu gi (k doi qua mau xam)
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return nil;
}

//tu dong di chuyen con tro vao o textfield
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

//nhan delegate kiem tra textfield rong hay khong
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //NSLog(@"%@ | %@ | %@",newText, NSStringFromRange(range), string);
    
    self.doneBarButton.enabled = ([newText length] > 0);
    
    return YES;
}
@end
