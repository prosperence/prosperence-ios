import Foundation
import CoreData


class Profile: NSManagedObject
{
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var profileName: String
    @NSManaged var createdate: NSDate
    @NSManaged var rememberPassword: NSNumber
}



class SimpleProfile: NSObject
{
    var username: String            = ""
    var password: String            = ""
    var profileName: String         = ""
    var createdate: NSDate          = NSDate()
    var rememberPassword: NSNumber  = NSNumber()
}