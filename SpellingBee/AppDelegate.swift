//
//  AppDelegate.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-05.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let uuid = self.activePack() {
            let deck = JapaneseDeck.all().first(where: { (deck) -> Bool in
                UUID(uuidString:deck.uuid) == uuid
            }) ?? JapaneseDeck.all().first!
            
            self.saveActivePack(pack: UUID(uuidString:deck.uuid)!)
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            let controller = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
            controller.deck = deck
            navigationController?.pushViewController(controller, animated: false)
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func activePack() -> UUID? {
        return UUID(uuidString: UserDefaults.standard.string(forKey: "activePack") ?? "")
    }
    
    func saveActivePack(pack: UUID) {
        UserDefaults.standard.set(pack.uuidString, forKey: "activePack")
        UserDefaults.standard.synchronize()
    }
    
    
    
    func isOnboardingFinished() -> Bool {
        return UserDefaults.standard.bool(forKey: "onboarding")
    }
    
    func saveOnboardingFinished() {
        UserDefaults.standard.set(true, forKey: "onboarding")
        UserDefaults.standard.synchronize()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
}

