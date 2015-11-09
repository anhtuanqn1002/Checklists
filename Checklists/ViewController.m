//
//  ViewController.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/2/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ViewController.h"
#import "ChecklistItem.h"
#import "Checklist.h"

@interface ViewController ()

@end

@implementation ViewController

//lấy đường dẫn thư mục chứa dữ liệu
//-(NSString *)documentsDirectory {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths firstObject];
//    return documentDirectory;
//}
//lấy đường dẫn thư mục ở documentsDirectory ở trên + tên file dữ liệu là "Checklists.plist" để thành 1 đường dẫn hoàn thiện
//method này tương đương với việc ghép 2 chuỗi lại với nhau, ta có thể dùng stringWithFormat thay cho phương thức ở dưới.
//-(NSString *)dataFilePath {
//    //có thể gọi như sau để thay câu lệnh bên dưới
//    //return [NSString stringWithFormat:@"%@/Checklists.plist", [self documentsDirectory]];
//    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
//}

//method này dùng để ghi nội dung xuống file ChecklistItems.
//Đầu tiên lấy nội dung từ mảng _items, sau đó ghi nó xuống file ChecklistItems
//archiver dùng để tạo 1 file dạng .plist, sau đó encodes mảng _items sang dữ liệu nhị phân để có thể viết xuống file Checklists
//............test git hub..........
//-(void)saveChecklistItems {
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:_items forKey:@"ChecklistItems"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}

#pragma mark - initViewController and loading data from Checklist.plist file
//-(void)loadChecklistItems {
//    
//    //lấy đường dẫn file dữ liệu
//    NSString *path = [self dataFilePath];
//    
//    /*Kiểm tra
//      nếu như: file dữ liệu tồn tại thì tiến hành
//        - tạo đối tượng data, tải nội dung file vào data.
//        - tạo đối tượng unarchiver từ data, sau đó dùng unarchiver để decode đống dữ liệu đó sang mảng _items
//      ngược lại thì: tạo 1 mảng động với 20 phần tử rỗng
//     */
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        
//        _items = [unarchiver decodeObjectForKey:@"ChecklistItems"];
//        [unarchiver finishDecoding];
//    } else {
//        _items = [[NSMutableArray alloc] initWithCapacity:20];
//    }
//}
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self loadChecklistItems];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = self.checklist.name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.checklist.items count];
}
-(UITableViewCell*)tableView: (UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    //lay cell tuong ung idnetifier = ChecklistItem
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    
    ChecklistItem *item = self.checklist.items[indexPath.row];
    
    //trong moi cell thi moi control lai duoc dinh danh bang 1 con so > 0. vi du: label duoc gan id = 1000
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    label.text = item.text;
    
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ChecklistItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    //[self saveChecklistItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)configureCheckmarkForCell:(UITableViewCell *)cell
                     withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    label.textColor= self.view.tintColor;
    if (item.checked == YES) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}
-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    //label.text = item.text;
    label.text = [NSString stringWithFormat:@"%ld: %@", (long)item.itemId, item.text];
}


#pragma mark - nhan delegate tu man hinh addItem
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
    NSInteger newRowIndex = [self.checklist.items count];
    [self.checklist.items addObject:item];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //lưu xuống dữ liệu xuống file
    //[self saveChecklistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//xoá 1 row trong table view
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    //[self saveChecklistItems];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    NSInteger index = [self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    //lưu xuống dữ liệu xuống file
    //[self saveChecklistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        
        //self la view hien tai, controller.delegate = self chinh la trao quyen cho xu ly cho view hien tai
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.checklist.items[indexPath.row];
    }
}








@end
