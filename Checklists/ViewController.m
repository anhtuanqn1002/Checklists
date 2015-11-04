//
//  ViewController.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/2/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "ViewController.h"
#import "ChecklistItem.h"

@interface ViewController ()
{
    ChecklistItem *_row0item;
    ChecklistItem *_row1item;
    ChecklistItem *_row2item;
    ChecklistItem *_row3item;
    ChecklistItem *_row4item;
    
    NSMutableArray *_items;
}
@end

@implementation ViewController

//lấy đường dẫn thư mục chứa dữ liệu
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    return documentDirectory;
}
//lấy đường dẫn thư mục ở documentsDirectory ở trên + tên file dữ liệu là "Checklists.plist" để thành 1 đường dẫn hoàn thiện
//method này tương đương với việc ghép 2 chuỗi lại với nhau, ta có thể dùng stringWithFormat thay cho phương thức ở dưới.
-(NSString *)dataFilePath {
    //có thể gọi như sau để thay câu lệnh bên dưới
    //return [NSString stringWithFormat:@"%@/Checklists.plist", [self documentsDirectory]];
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}

//method này dùng để ghi nội dung xuống file ChecklistItems.
//Đầu tiên lấy nội dung từ mảng _items, sau đó ghi nó xuống file ChecklistItems
//archiver dùng để tạo 1 file dạng .plist, sau đó encodes mảng _items sang dữ liệu nhị phân để có thể viết xuống file Checklists
//............test git hub..........
-(void)saveChecklistItems {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Documents folder8 is %@", [self documentsDirectory]);
    NSLog(@"Data file path is %@", [self dataFilePath]);
    _items = [[NSMutableArray alloc] initWithCapacity:20];
    
    ChecklistItem *item;
    
    item = [[ChecklistItem alloc] init];
    item.text = @"Walk the dog";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc] init];
    item.text = @"Brush my teeth";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc] init];
    item.text = @"Learn iOS development";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc] init];
    item.text = @"Soccer practice";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc] init];
    item.text = @"Eat ice cream";
    item.checked = NO;
    [_items addObject:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}
-(UITableViewCell*)tableView: (UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    //lay cell tuong ung idnetifier = ChecklistItem
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    
    ChecklistItem *item = _items[indexPath.row];
    
    //trong moi cell thi moi control lai duoc dinh danh bang 1 con so > 0. vi du: label duoc gan id = 1000
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    label.text = item.text;
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ChecklistItem *item = _items[indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [self saveChecklistItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)configureCheckmarkForCell:(UITableViewCell *)cell
                     withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}
-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    [_items removeObjectAtIndex:indexPath.row];
//    NSArray *indexPaths = @[indexPath];
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//}


#pragma mark - nhan delegate tu man hinh addItem
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //lưu xuống dữ liệu xuống file
    [self saveChecklistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//xoá 1 row trong table view
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [_items removeObjectAtIndex:indexPath.row];
    [self saveChecklistItems];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    //lưu xuống dữ liệu xuống file
    [self saveChecklistItems];
    
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
        controller.itemToEdit = _items[indexPath.row];
    }
}








@end
