//
//  Copyright © 2016 Schnaub. All rights reserved.
//

import Foundation

final class ImageDownloader {

    
    class func downloadImage(url: NSURL, completion:(image: UIImage?) -> Void) -> NSURLSessionDataTask? {
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(image: nil)
                return
            }
            var image: UIImage?
            defer {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(image: image)
                })
            }
            guard let data = data else { return }
            image = UIImage(data: data)
        })
        dataTask.resume()
        return dataTask
    }
    
}
