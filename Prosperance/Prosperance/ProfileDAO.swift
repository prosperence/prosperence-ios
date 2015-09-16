import Foundation
import CoreData
import UIKit


func createProfile(username: String, password: String, rememberPassword: NSNumber, profileName: String)
{
    var newProfile = SimpleProfile()
    
    newProfile.username = username
    newProfile.password = password
    newProfile.rememberPassword = rememberPassword
    newProfile.profileName = profileName
    
    createProfile(newProfile)
}



func createProfile(newProfile: SimpleProfile)
{
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var entityDescription = NSEntityDescription.entityForName("Profile", inManagedObjectContext: context)
    var profile = Profile(entity: entityDescription!, insertIntoManagedObjectContext: context)
    
    profile.username            = newProfile.username
    profile.rememberPassword    = newProfile.rememberPassword
    profile.profileName         = newProfile.profileName
    profile.createdate          = NSDate()
    
    //////////////////////////////////////////////////////
    // Only create password if rememberPassword is true //
    //////////////////////////////////////////////////////
    if(newProfile.rememberPassword === 1)
    {
        profile.password = newProfile.password
    }
    else
    {
        profile.password = ""
    }
    
    var error: NSError? = nil
    if !context.save(&error)
    {
        println("Unresolved error [\(error)] [\(error?.userInfo)]")
    }
}



func updateProfile(existingProfile: Profile, updatedProfile: SimpleProfile)
{
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    existingProfile.username            = updatedProfile.username
    existingProfile.rememberPassword    = updatedProfile.rememberPassword
    existingProfile.profileName         = updatedProfile.profileName
    
    ////////////////////////////////////////////////////
    // Only save password if rememberPassword is true //
    ////////////////////////////////////////////////////
    if(updatedProfile.rememberPassword === 1)
    {
        existingProfile.password = updatedProfile.password
    }
    else
    {
        existingProfile.password = ""
    }
    
    var error: NSError? = nil
    if !context.save(&error)
    {
        println("Unresolved error [\(error)] [\(error?.userInfo)]")
    }
}