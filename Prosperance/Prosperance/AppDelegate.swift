import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        splitViewController.delegate = self
        
        //////////////////////////////////////////////////////////
        // Always keep split screen open, even in portrait view //
        //////////////////////////////////////////////////////////
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible

        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController

        ///////////////////////////////////////////////////////////////////////
        // sleep for a second - allow our beautiful splash screen to be seen //
        ///////////////////////////////////////////////////////////////////////
        sleep(3)
        
        NoProfileSelectedViewController.self
        ProfileSelectedViewController.self
        LogginInViewController.self
        
        return true
    }

    
    
    func applicationWillResignActive(application: UIApplication)
    {
    }
    
   
    
    func applicationDidEnterBackground(application: UIApplication)
    {
    }

    
    
    func applicationWillEnterForeground(application: UIApplication)
    {
    }

    
    
    func applicationDidBecomeActive(application: UIApplication)
    {
    }

    
    
    func applicationWillTerminate(application: UIApplication)
    {
        self.saveContext()
    }

    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool
    {
        if let secondaryAsNavController = secondaryViewController as? DetailViewNavigationController
        {
            if secondaryAsNavController.selectedProfile == nil
            {
                //////////////////////////////////////////////////////////////////
                // Return true to indicate that we have handled the collapse by //
                // doing nothing; the secondary controller will be discarded.   //
                //////////////////////////////////////////////////////////////////
                return true
            }
        }
        return false
    }
    
    
    
    lazy var applicationDocumentsDirectory: NSURL =
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    
    
    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = NSBundle.mainBundle().URLForResource("Prosperance", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? =
    {
        //////////////////////////////////////
        // Create the coordinator and store //
        //////////////////////////////////////
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Prosperance.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil
        {
            coordinator = nil
            /////////////////////////////
            // Report any error we got //
            /////////////////////////////
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "Prosperance", code: 9999, userInfo: dict as [NSObject : AnyObject])
            
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            println("Error [\(error)]")

        }
        
        return coordinator
    }()

    
    
    lazy var managedObjectContext: NSManagedObjectContext? =
    {
        let coordinator = self.persistentStoreCoordinator
        
        if coordinator == nil
        {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    
    
    func saveContext ()
    {
        if let moc = self.managedObjectContext
        {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error)
            {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                println("Error [\(error)]")
            }
        }
    }
}