//
//  DataModel.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/7/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"
@implementation DataModel

//lấy đường dẫn thư mục chứa dữ liệu
-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    //NSLog(@"%@", documentDirectory);
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
-(void)saveChecklist {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)loadChecklists {
    
    //lấy đường dẫn file dữ liệu
    NSString *path = [self dataFilePath];
    
    /*Kiểm tra
     nếu như: file dữ liệu tồn tại thì tiến hành
     - tạo đối tượng data, tải nội dung file vào data.
     - tạo đối tượng unarchiver từ data, sau đó dùng unarchiver để decode đống dữ liệu đó sang mảng _items
     ngược lại thì: tạo 1 mảng động với 20 phần tử rỗng
     */
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.lists = [unarchiver decodeObjectForKey:@"ChecklistItems"];
        [unarchiver finishDecoding];
    } else {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

-(id)init {
    if ((self = [super init])) {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}
//method này chạy để đăng kí giá trị mặc định cho key ChecklistIndex. Khi mới chạy ứng dụng đầu tiên luôn thì giá trị mặc định cho key là -1
-(void)registerDefaults {
    NSDictionary *dictionary = @{
                                 @"ChecklistIndex": @-1,
                                 @"FirstTime": @YES,
                                 @"ChecklistItemId": @0
                                 };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

-(NSInteger)indexOfSelectedChecklist {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
}
-(void)setIndexOfSelectedChecklist:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"ChecklistIndex"];
}

-(void)handleFirstTime {
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    if (firstTime) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = @"List";
        
        [self.lists addObject:checklist];
        [self setIndexOfSelectedChecklist:0];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
    }
}

//dùng để sort danh sách checklist. @selector ta phải định nghĩa 1 method tên là compare: ở trong đối tượng Checklist để biết sẽ sort theo tiêu chí nào.
-(void)sortChecklists {
    [self.lists sortUsingSelector:@selector(compare:)];
}

+(int)nextChecklistItemId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemId = [userDefaults integerForKey:@"ChecklistItemId"];
    [userDefaults setInteger:itemId+1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];
    return (int)itemId;
}
@end
