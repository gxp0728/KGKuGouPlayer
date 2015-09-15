//
//  AppDelegate.m
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import "AppDelegate.h"
#import "KGWelcomePageViewController.h"
#import "KGHomePageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //程序启动完毕。1.取得本App的版本号
    // NSString*newVersion=infoDict[  kCFBundleVersionKey ];
    // [NSBundle mainBundle].version
    NSDictionary*infoDict=  [NSBundle  mainBundle].infoDictionary;
      NSString*newVersion=infoDict[@"CFBundleVersion"];
    NSLog(@"CFBundleVersion:%@",newVersion);
    //2.和之前保存的app版本号进行对比，如果相同，则从主页启动，如果不同从欢迎页启动
    NSString*oldVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"CFBundleVersion"];
    if (oldVersion==nil) {//如果等于nil 等于第一次装，一定要走欢迎页
        UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];//首先找到storyboard
        KGWelcomePageViewController*welVC=   [storyboard instantiateViewControllerWithIdentifier:@"welPage"];//再从story转到下个页面
        self.window.rootViewController=welVC;//将根控制器设置为本地音乐 下次启动就不再显示欢迎页面

    }else{
        if ([oldVersion isEqualToString:newVersion]) {
            //如果旧的版本号和新的版本号相同 从主页启动
            UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];//首先找到storyboard
            KGHomePageViewController*homeVC=   [storyboard instantiateViewControllerWithIdentifier:@"homePage"];//再从story转到下个页面
            self.window.rootViewController=homeVC;//将根控制器设置为本地音乐 下次启动就不再显示欢迎页面

            
        }else{
            //如果旧的版本号和新的版本号不相同 从欢迎页启动
            UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];//首先找到storyboard
            KGWelcomePageViewController*welVC=   [storyboard instantiateViewControllerWithIdentifier:@"welPage"];//再从story转到下个页面
            self.window.rootViewController=welVC;//将根控制器设置为本地音乐 下次启动就不再显示欢迎页面

        }
    }
    //3.如果版本不同，把新的App版本号保存起来
    [[NSUserDefaults standardUserDefaults]setObject:newVersion forKey:@"CFBundleVersion"];//用偏好保存
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.neuedu.KGKuGouPlayer" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KGKuGouPlayer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KGKuGouPlayer.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
