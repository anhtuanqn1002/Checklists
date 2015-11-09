//
//  ListDetailViewController.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/5/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"


@implementation ListDetailViewController
{
    NSString *_iconName;
}
//Kiểm tra: nếu checklistToEdit tồn tại, nghĩa là nó là view Edit thì đổi tên view thành Edit Checklist, đổi đề mục bằng tên checklist
-(void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.checklistToEdit != nil) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        
        //nếu như là edit checklist thì lấy tên icon gán vào cho _iconName
        //còn không thì khởi tạo icon mới với tên _iconName mặc định là Folder
        _iconName = self.checklistToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:_iconName];
}

//method này di chuyển con trỏ chuột vào ô textfield tự động
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

//The event of Cancel button. Sending a delegate to things.
-(IBAction)cancel {
    [self.delegate listDetailViewControllerDidCancel:self];
}
//the even of done button. Sending a delegate to things. If checklist == nil: sending a delegate FinishAdding, other sending a FinishEditing
-(IBAction)done {
    if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        
        //thay đổi iconImage
        checklist.iconName = _iconName;
        
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    } else {
        self.checklistToEdit.name = self.textField.text;
        self.checklistToEdit.iconName = _iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    } else {
        return nil;
    }
}
//method kiểm tra mọi sự thay đổi của textfield, nếu textfield rỗng thì nút done bị ẩn đi. Nếu method return YES tức là cho phép hiển thị sự thay đổi trên textfield, return NO thì không cho.
-(BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        _iconName = @"Folder";
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}
-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName {
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
