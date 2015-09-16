import UIKit


class ProfileSelectedViewController: UIViewController
{
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var profile: Profile?
    var updatedSimpleProfile: SimpleProfile?
    
    
    
    override func viewDidLoad()
    {
        updateScreen()
    }
    
    
    
    func updateScreen()
    {
        profileNameLabel.text = profile!.profileName
        usernameLabel.text = profile!.username
    }
   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "editProfile")
        {
            let vc = segue.destinationViewController as! EditProfileViewController
            vc.profile = self.profile
        }
        else if(segue.identifier == "loginProfile")
        {
            let vc = segue.destinationViewController as! LogginInViewController
            vc.profile = self.profile
        }
    }
    
    
    
    @IBAction func handleEditProfileSaved(seague: UIStoryboardSegue)
    {
        updateProfile(profile!, updatedSimpleProfile!)
        updateScreen()
    }
}

