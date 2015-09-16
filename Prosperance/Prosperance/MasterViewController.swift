import UIKit
import CoreData


class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    var detailViewController: ProfileSelectedViewController? = nil
    var newProfile: SimpleProfile? = nil
    @IBOutlet var uiTableView: UITableView!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let split = self.splitViewController
        {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? ProfileSelectedViewController
        }
    }
    
    
    
    @IBAction func handleAddButtonInMaster(seague: UIStoryboardSegue)
    {
        if(newProfile != nil)
        {
            createProfile(newProfile!)
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow()
            {
                /////////////////////////////////////////////////////////////////////////////////////
                // get the currently selected profile and set it in the controller for the details //
                /////////////////////////////////////////////////////////////////////////////////////
                let selectedProfile = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Profile
                let navController = segue.destinationViewController as! DetailViewNavigationController
                navController.selectedProfile = selectedProfile
            }
        }
    }

    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            var error: NSError? = nil
            if !context.save(&error)
            {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                println("Error [\(error)]")
            }
        }
    }

    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        let profile = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Profile
        
        cell.textLabel?.text = profile.profileName
        
        var image : UIImage = UIImage(named: "user_profile")!
        cell.imageView?.image  = image
        
    }

    
    
    var fetchedResultsController: NSFetchedResultsController
    {
        if _fetchedResultsController != nil
        {
            return _fetchedResultsController!
        }
            
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()

        let entity = NSEntityDescription.entityForName("Profile", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "createdate", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = [sortDescriptor]
            
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
            
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error)
        {
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            println("Error [\(error)]")
        }
            
        return _fetchedResultsController!
    }
    
    
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.beginUpdates()
    }

    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        switch type
        {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {
        switch(type) {
            
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    configureCell(tableView.cellForRowAtIndexPath(indexPath)!, atIndexPath: indexPath)
                }
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.insertRowsAtIndexPaths([newIndexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.endUpdates()
    }
}