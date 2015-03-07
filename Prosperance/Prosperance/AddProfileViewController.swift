import UIKit


class AddProfileViewController: UIViewController
{
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberPasswordSwitch: UISwitch!
    var simpleProfile = SimpleProfile()

    
    
    @IBAction func handleUIUpdate(sender: AnyObject)
    {
        simpleProfile.profileName       = profileNameTextField.text
        simpleProfile.username          = usernameTextField.text
        simpleProfile.password          = passwordTextField.text
        simpleProfile.rememberPassword  = rememberPasswordSwitch.on == true ? 1 : 0
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "saveProfile")
        {
            var mvc = segue.destinationViewController as MasterViewController
            mvc.newProfile = simpleProfile;
        }
    }
}