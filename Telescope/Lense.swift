
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import Foundation

class Lense {
    
    //The base endpoint shouldn't be modifiable outside of this class
    private let apiEndpoint = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=starcraft"
    
    func requestRecords(withCompletionHandler completionAction: @escaping ([TelescopeRecord]) -> Void) {
        
        var records = [TelescopeRecord]()
        
        guard let endpointURL = URL(string: apiEndpoint) else {
            completionAction(records)
            return
        }
        
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
        task.resume()
    }
    
}
