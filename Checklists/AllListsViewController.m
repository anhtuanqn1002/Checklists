//
//  AllListsViewController.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/5/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "AllListsViewController.h"
#import "ViewController.h"
#import "ChecklistItem.h"
#import "DataModel.h"

@implementation AllListsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

//phương thức này để xác định section nào có bao nhiêu row. Vì chỉ có 1 section nên hiện tại return về 3 row mặc định
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.lists count];
}

//phương thức và phương thức trên tự động chạy khi bắt đầu sử dụng màn hình table view
//tiến hành định nghĩa các cell và trả về 1 cell, từ cell đó sẽ được table view show ra
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //phương thức dequeueReusableCellWithIdentifire sẽ xác định xem cell có identifier đó đã tồn tại hay chưa
    //nếu chưa thì trả về nil (nếu nil thì tiến hành tạo 1 cell mới)
    //cơ chế của việc tạo cell này là nó sẽ tạo ra tất cả các cell có thể nhìn thấy trên view
    //những cell ẩn (cuộn lên mới thấy) thì nó sẽ sử dụng lại (lúc này kết quả trả về của phương thức dequeueReusableCellWithIdentifier sẽ != nil
    //trong trường hợp này mới khởi tạo nên cell nhận lại sẽ toàn == nil và nó sẽ tiến hành tạo cell mới.
    /*chú ý: 4 dòng code phía dưới có thể thay thế bằng dòng UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
            forIndexPath:indexPath]; Dòng này cũng là để tạo 1 cell nhưng nó bao gồm cả việc kiểm tra xem cell == nil hay không, nếu == nil nó sẽ tự tạo cell mới
     Tuy nhiên với cách dùng indexPath thì phải xác định cell mẫu ngoài storyboard trước, hoặc phải registerClass ở method viewDidLoad trước
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"%@",[self dataFilePath]);
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

//phương thức sẽ xử lý sự kiện chọn vào 1 row nào đó
//khi chọn vào 1 row nào đó nó sẽ show cái màn hình checklist ra (chuyển từ all list sang 1 checklist đơn)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //khi người dùng chọn 1 row trên table view controller thì ta lưu lại vị trí row được chọn với key là ChecklistIndex.
    //để khi bắt đầu chạy lại ứng dụng sau khi off thì nó sẽ lấy giá trị row hiện tại ra và show như lúc trước khi tắt ứng dụng.
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    //đối tượng sender được gửi đi sẽ vào method prepareForSegue chờ xử lý chứ nó không phải chuyển sender qua cái view khác.
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}


#pragma mark - Take a delegate

//method này sẽ được gọi trước khi segue thực hiện chuyển view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //nếu như segue.identifier là ShowChecklist thì gán checklist = sender
    //nếu như segue.identifier là AddChecklist thì gán delegate = self và cho biết là cái này là Add chứ không phải edit
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ViewController *controller = segue.destinationViewController;
        controller.checklist = sender;
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.checklistToEdit = nil;
    }
}

#pragma mark - implement the following delegate method

-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist {
    NSInteger newRowIndex = [self.dataModel.lists count];
    [self.dataModel.lists addObject:checklist];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    NSInteger index = [self.dataModel.lists indexOfObject:checklist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = checklist.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//delete a row at the AllListView
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

//event when you clicked to icon accessoryButton
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath {
    //định danh cho 1 storyboard là ListNavigationController. gọi đối tượng storyboard và phương thức lấy ra cái navigation cần là ListNavigationController
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    
    //sau khi lấy ra cái navigation thì tiến hành lấy ra cái tableview muốn lấy, ở đây là lấy topViewController = lấy ListDetailViewController
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;

    //trao delegate cho thằng self (là thằng hiện tại), nghĩa là xác định thằng nào sẽ xử lý delegate cho thằng ListDetailViewController(controller)
    controller.delegate = self;
    
    //lấy checklist tương ứng ra từ _lists, sau đó sửa thông tin đối tượng checklistToEdit. Cuối cùng là show nội dung của view hiện tại
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    controller.checklistToEdit = checklist;
    [self presentViewController:navigationController animated:YES completion:nil];
}

//khi back trở lại view khác, thì delegate nó sẽ thông báo cho thằng này là đã qua view khác rồi, vậy nên giá trị key ChecklistIndex sẽ được thay = -1 (không chọn)
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}

//Sau khi lưu thông tin vào NSUserDefaults. Mỗi khi chạy lại ứng dụng ta sẽ xét có row nào trước đó đc lưu lại không, nếu có thì show vào chỗ đó ngay
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //dòng này uỷ thác việc xử lý khi chuẩn bị show view ra cho thằng này
    self.navigationController.delegate = self;
    
    NSInteger index = [self.dataModel indexOfSelectedChecklist];
    if (index >= 0 && index < [self.dataModel.lists count]) {
        Checklist *checklist = self.dataModel.lists[index];
        //nếu như có cái row trước khi ứng dụng tắt được chọn thì show ngay cái row đó ra
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}

@end
