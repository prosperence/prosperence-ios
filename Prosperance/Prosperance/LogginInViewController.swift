import UIKit


class LogginInViewController: UIViewController
{
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var errorTextFeild: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var busyDiv: UIActivityIndicatorView!
    
    var profile: Profile?
    var errorMessage: String = ""
    var sessionId: String = ""
   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateScreen(false)
    }
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        /////////////////////////////////////////////////////////////////////////////////
        // If remember password set to false, clear password when leaving Login screen //
        /////////////////////////////////////////////////////////////////////////////////
        if(profile?.rememberPassword === false)
        {
            profile?.password = ""
        }
    }

    
    
    func updateScreen(isBlocked: Bool)
    {
        if(isBlocked)
        {
            busyDiv.startAnimating()
            
            passwordTextFeild.userInteractionEnabled = false
            loginButton.enabled = false
        }
        else
        {
            busyDiv.stopAnimating()
            
            // Get host from environment variables
            let dict = NSProcessInfo.processInfo().environment
            let host = dict["HOST"] as? String
            
            urlTextField.text = host
            passwordTextFeild.text = profile?.password
            passwordTextFeild.userInteractionEnabled = true
            errorTextFeild.text = errorMessage
        
            //////////////////////////////////////////////////////////
            // Set button text depending on whether error displayed //
            //////////////////////////////////////////////////////////
            if(errorMessage.isEmpty)
            {
                loginButton.setTitle("Login", forState: UIControlState.Normal)
            }
            else
            {
                loginButton.setTitle("Try Again", forState: UIControlState.Normal)
            }

            loginButton.enabled = true
        }
    }
    
    
    
    @IBAction func handleUIUpdate(sender: AnyObject)
    {
        profile?.password = passwordTextFeild.text
    }
    
   
    
    @IBAction func handleLoginButton(sender: AnyObject)
    {
        updateScreen(true)
        
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(backgroundQueue,
        {
            var wasSuccessful = self.authWithServer()
            
            if(wasSuccessful)
            {
                /////////////////////////////////////////////////////////////////////////////////////
                // we were successful - keep the screen locked - and transition to the next screen //
                /////////////////////////////////////////////////////////////////////////////////////
                dispatch_async(dispatch_get_main_queue())
                {
                    self.showUiWebView()
                }
            }
            else
            {
                ///////////////////////////////////////////////////////////////////////////////////////////
                // there were issues - update the screen with them - unlock it - allow user to try again //
                ///////////////////////////////////////////////////////////////////////////////////////////
                dispatch_async(dispatch_get_main_queue())
                {
                    self.updateScreen(false)
                }
            }

        })
    }
    
    
    
    func showUiWebView() -> Void
    {
        var wvc = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as WebViewController
        wvc.profile = self.profile
        wvc.sessionId = self.sessionId
        self.presentViewController(wvc, animated: false, completion: nil)
    }
    
   
    
    
    func authWithServer() -> Bool
    {
        var sessionId = getSessionId(self.profile!)
        
        if(!sessionId.error.isEmpty)
        {
            errorMessage = "Invalid username or password. Please check and try again."
            self.sessionId = ""
            return(false)
        }
        else
        {
            self.sessionId = sessionId.success
            return(true)
        }
    }
}