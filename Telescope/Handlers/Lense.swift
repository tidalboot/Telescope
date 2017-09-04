
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.

import Foundation

//Lense is in charge of all network requests; Any additional network requests that need to be added should be done so in here
class Lense {
    // MARK: - Local Properties 💻
    //The base endpoint shouldn't be modifiable outside of this class
    private let apiEndpoint = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    // MARK: - Custom Methods 🔮
    //For safety we'll always pass a typed array of Telescope Records through to our completion block; The Telecope Record parser also returns a typed array of records no matter what to fit this
    func requestRecords(withCompletionHandler completionAction: @escaping ([TelescopeRecord]) -> Void, andSearchQuery searchQuery: String) {
        
        //First we set up the endpoint that we want to hit, including our searchquery by replacing any spaces with + symbols to match what the API is after
        let endpointToUse = "\(apiEndpoint)&tags=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        
        var records = [TelescopeRecord]()
        
        //Then we ensure that our endpoint is still a valid URL
        guard let endpointURL = URL(string: endpointToUse) else {
            completionAction(records)
            return
        }
        
        //Create our data task
        let task = URLSession.shared.dataTask(with: endpointURL) { (rawData, rawResponse, rawError) in
            
            if (rawError != nil || rawData == nil) {
                completionAction(records)
                return
            }
            
            guard let data = rawData else {
                completionAction(records)
                return
            }
            
            records = TelescopeRecord.parseRecords(fromRawData: data)
            completionAction(records)
        }
        //And kick it off
        task.resume()
    }
}
