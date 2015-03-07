import UIKit


class DetailViewNavigationController: UINavigationController
{
    
    
    var selectedProfile: Profile?
    {
        didSet
        {
            println("set selectedProfile in DVNC");
        }
    }

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(selectedProfile == nil)
        {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("noProfileSelectedView") as NoProfileSelectedViewController
            self.setViewControllers([vc], animated: false)
        }
        else
        {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("profileSelectedView") as ProfileSelectedViewController
            vc.profile = selectedProfile!
            self.setViewControllers([vc], animated: false)
        }
    }
}