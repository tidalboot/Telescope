//
//  TelescopRecord.swift
//  Telescope
//
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import Foundation



//We'll go for a class over a struct as any TelescopRecord objects will be initialised here and should never need to be copied anywhere for modification
class TelescopeRecord {
    
    //All properties should be read only, leaving the initialiser to do all of the work, the app is an image gallery and so by definition is read-only itself.
    
    let Title: String
    let DateTaken: String
    let ImageDimensions: String
    let Author: String
    //Whilst the API by default returns the medium image URL (_m) we can simply infer the original sized image by simply omitting the trailing m.
    let Images: (Medium: String, Original: String?)
    
    
    //We don't want this being accessed outside of this scope
    private init(withTitle title: String,
         dateTaken: String,
         dimensions: String,
         author: String,
         andImageURL imageURL: String) {
        Title = title
        DateTaken = dateTaken
        ImageDimensions = dimensions
        Author = author
        
        var originalImageURL: String?
        
        //First we need to get all of the URL before the file extension definition
        let originalImageSize = imageURL.components(separatedBy: ".jpg")
        if (!originalImageSize.isEmpty) {
            //Next we get the value on the left side of the file extension
            if let firstSegment = originalImageSize.first {
                //And finally we check if the _m identifier is available
                //NOTE: We need to do it this way rather than simply searching for _m as the image URL itself could contain _m at any point; We're only interested in removing it from the very end if it's present as this is where it's a predefinde modifier rather than part of the URL itself.
                if (firstSegment.suffix(2) == "_m") {
                    //And if so drop it to get our original image URL
                    originalImageURL = String(firstSegment.dropLast(2))
                }
            }
        }
        Images = (Medium: imageURL, Original: originalImageURL)
    }
    
    
    //For ease of access and safety we always want this to return, at least, an empty typed array
    class func parseRecords(fromRawData rawData: Data?) -> [TelescopeRecord] {
        var telescopeRecords = [TelescopeRecord]()
        
        guard let data = rawData else {
            return telescopeRecords
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                return telescopeRecords
            }
            
            guard let records = json["items"] as? [[String : Any]] else {
                return telescopeRecords
            }
            
            for record in records {
                
                let title = record["title"] as? String ?? "N/A"
                
                var dateTaken = "N/A"
                if let rawDate = record["date_taken"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    if let dateFound = dateFormatter.date(from: rawDate) {
                        //We reuse our existing date formatter but simply change the format as they're very expensive to make
                        dateFormatter.dateFormat = "MMM dd, yyyy"
                        dateTaken = dateFormatter.string(from: dateFound)
                    }
                }
                
                telescopeRecords.append(TelescopeRecord(
                    withTitle: title,
                    dateTaken: dateTaken,
                    dimensions: "",
                    author: "",
                    andImageURL: "")
                )
            }
            
            return telescopeRecords
        } catch {
            return telescopeRecords
        }
    }
    
}
