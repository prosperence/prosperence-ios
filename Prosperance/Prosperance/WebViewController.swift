import UIKit
import WebKit


class WebViewController: UIViewController
{

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var busyDiv: UIActivityIndicatorView!

    var profile: Profile?
    var sessionId: String?

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadURL()
    }


    
    func loadURL()
    {
        setCookies()
        
        // Get host from environment variables
        let dict = NSProcessInfo.processInfo().environment
        let host = dict["HOST"] as? String
        
        //////////////////////
        // load our RF page //
        //////////////////////
        var url = NSURL(string:host!)
        var req = NSURLRequest(URL:url!)
        self.webView.loadRequest(req)
    }
    
    
    
    func setCookies()
    {
        ////////////////////
        // set our cookie //
        ////////////////////
        var cookieProperties = NSMutableDictionary()
        cookieProperties.setObject("sessionId", forKey:NSHTTPCookieName);
        cookieProperties.setObject(sessionId!, forKey:NSHTTPCookieValue);
        
        // Get host from environment variables
        let dict = NSProcessInfo.processInfo().environment
        let host = dict["HOST"] as? String
        
        cookieProperties.setObject(host!, forKey:NSHTTPCookieDomain);
        cookieProperties.setObject("/", forKey:NSHTTPCookiePath);
        
        var cookie = NSHTTPCookie(properties: cookieProperties)
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        storage.setCookie(cookie!)
    }
    
    
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        if((webView.request?.URL) != nil)
        {
            var request = webView.request!
            var url = request.URL
            
            println("in webViewDidStartLoad : went to page [\(url)] as [\(request.HTTPMethod)]")
        }
    }
    
    
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        if((webView.request?.URL) != nil)
        {
            var request = webView.request!
            var url = request.URL
            
            println("in webViewDidFinishLoad : went to page [\(url)] as [\(request.HTTPMethod)] : with last Path Component [\(url.lastPathComponent)]")
            
            if(url.lastPathComponent?.hasSuffix("logout") == true || url.lastPathComponent?.hasSuffix("login") == true)
            {
                var loggedOutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loggedOutViewController") as LoggedOutViewController
                self.presentViewController(loggedOutViewController, animated: false, completion: nil)
            }
        }
    }
}