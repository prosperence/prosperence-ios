import Foundation



func getSessionId(profile: Profile) -> (success: String, error: String)
{
    // Get host from environment variables
    let dict = NSProcessInfo.processInfo().environment
    let host = dict["HOST"] as? String
    
    /////////////////////////////
    // Build http post request //
    /////////////////////////////
    var url = host! + "/auth/local"
    let jsonString = "{\"email\": \"\( profile.username )\", \"password\": \"\( profile.password)\"}"
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    
    if let responseData = NSURLConnection.sendSynchronousRequest(request,returningResponse: nil, error:nil) as NSData!
    {
        if let responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as? NSDictionary
        {
            if let token: String? = responseDict.valueForKey("token") as? String
            {                
                return(token!, "")
            }
            else
            {
                ///////////////////////////////////////////////////////////////////
                // Application / Auth error - did not receive a proper UUID back //
                ///////////////////////////////////////////////////////////////////
                return("", "Did not receive a proper token back")
            }
        }
        else
        {
            ////////////////////////////////////////////////////////
            // System error - did not receive valid json response //
            ////////////////////////////////////////////////////////
            return("", "Did not receive a valid json response")
        }
    }
    else
    {
        /////////////////////////////////////////////////////////////////////
        // Local connection issue - could not get ahold of the outside URL //
        /////////////////////////////////////////////////////////////////////
        return("", "Could not get ahold of the outside URL")
    }
}