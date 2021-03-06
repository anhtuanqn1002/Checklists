//
//  AppDelegate.m
//  Checklists
//
//  Created by Nguyen Van Anh Tuan on 11/2/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "AppDelegate.h"
#import "AllListsViewController.h"
#import "DataModel.h"

@interface AppDelegate ()
{
    DataModel *_dataModel;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //khởi tạo _dataModel
    _dataModel = [[DataModel alloc] init];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    AllListsViewController *controller = navigationController.viewControllers[0];
    controller.dataModel = _dataModel;
    
    // register notification types
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //khởi tạo local notifications
    //khi khởi tạo 1 notification thì phải set giá trị fireDate cho nó, giá trị này quy định thời gian hiện notification.
    //Trong ví dụ này set nó là 10s kể từ khi bắt đầu chạy app.
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"I am a local notification!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)saveData {
    [_dataModel saveChecklist];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification %@", notification);
}


@end
