import UIKit


class HomeViewController: UISplitViewController
{
    var window: UIWindow?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //////////////////////////////////////////////////////////
        // Always keep split screen open, even in portrait view //
        //////////////////////////////////////////////////////////
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }

    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
