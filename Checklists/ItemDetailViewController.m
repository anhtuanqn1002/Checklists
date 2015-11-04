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

-(void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"chay vao additem");
    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
        //NSLog(@"chay vao edit item");
    }
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
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    } else {
        self.itemToEdit.text = self.textField.text;
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
