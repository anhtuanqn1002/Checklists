//
//  ListDetailViewController.h
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/5/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDetailViewController;
@class Checklist;

@protocol ListDetailViewControllerDelegate <NSObject>

-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end
@interface ListDetailViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak)IBOutlet UITextField *textField;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, weak)id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Checklist* checklistToEdit;

-(IBAction)cancel;
-(IBAction)done;

@end
