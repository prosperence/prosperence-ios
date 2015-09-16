import UIKit


class EditProfileViewController: UIViewController
{
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberPasswordSwitch: UISwitch!
    var simpleProfile = SimpleProfile()
    var profile:Profile?
    
    
    
    override func viewDidLoad()
    {
        profileNameTextField.text   = profile?.profileName
        usernameTextField.text      = profile?.username
        passwordTextField.text      = profile?.password
        rememberPasswordSwitch.on   = profile?.rememberPassword === 1 ? true : false
    }
    
    
    
    @IBAction func handleUIUpdate(sender: AnyObject)
    {
        simpleProfile.profileName       = profileNameTextField.text

        simpleProfile.username          = usernameTextField.text
        simpleProfile.password          = passwordTextField.text
        simpleProfile.rememberPassword  = rememberPasswordSwitch.on == true ? 1 : 0
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        handleUIUpdate(sender!)
        
        if(segue.identifier == "saveEditedProfile")
        {
            var psvc = segue.destinationViewController as! ProfileSelectedViewController
            psvc.updatedSimpleProfile = simpleProfile
        }
    }
}