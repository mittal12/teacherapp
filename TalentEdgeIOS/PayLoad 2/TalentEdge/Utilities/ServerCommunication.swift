
import UIKit
import Foundation
import MobileCoreServices

class ServerCommunication: NSObject {
    
//    private static var __once: () = {
//            Static.instance = ServerCommunication()
//        }()
    
     static let singleton: ServerCommunication  = {
//        let sharedInstance:ServerCommunication = {
            let instance = ServerCommunication ()
            return instance
//        } ()
//        return sharedInstance

    }()
   // teacher1
 //   password
    
    //var requestUrl = "http://sliq.talentedge.in/Api/" //prduction
       // var requestUrl = "http://staging.talentedge.in/dev/Api/"// dev
    
    var requestUrl = "http://staging.talentedge.in/LMS/Api/"  //qa

    func requestWithPost(_ api : String , headerDict:[String:String], postString : String, success:@escaping (NSDictionary)-> Void, failure:@escaping (NSDictionary)-> Void) -> Void{
        self.requestForData(requestUrl + api,headerDict: headerDict, postString: postString, success: success, failure: failure)
    }
    
    func requestWithPostToSendImages(_ api : String, headerDict:[String:String] ,param : NSMutableDictionary?, success:@escaping (NSDictionary)-> Void, failure:@escaping (NSDictionary)-> Void) -> Void{
        self.imageUploadRequest(requestUrl + api,headerDict:headerDict, param: param, success: success, failure: failure)
    }
    
    func requestForData(_ urlString:String, headerDict:[String:String], postString:String?, success:@escaping (NSDictionary)->Void, failure:@escaping (NSDictionary)-> Void) ->Void{
        print("URL :::: \(urlString)", terminator: "")
        print("/n Post String ::::: \(postString)", terminator: "")
        print("/n Header ::::: \(headerDict)", terminator: "")

        let request = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        if (postString != "") {
            let postBody = postString!.data(using: String.Encoding.utf8, allowLossyConversion: false)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let contentLength = "\(postBody?.count)"
            request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
//            request.setValue("c8a1ad1332716aa15752422360e739a5", forHTTPHeaderField: "public-key")
            request.allHTTPHeaderFields = headerDict
            request.httpMethod = "POST"
            request.httpBody = postBody
            
        }else{
            request.httpMethod = "GET"
//            request.setValue("c8a1ad1332716aa15752422360e739a5", forHTTPHeaderField: "public-key")
        }
        DispatchQueue.main.async(execute: { () -> Void in
            DataUtils.addLoadIndicator()
        })
        URLSession.shared.dataTask(with: (request as URLRequest), completionHandler: { (data, response, error) -> Void in
            var json: AnyObject?
            
            if error == nil {
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!, terminator: "")
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    if (json!.value(forKey: "status") as AnyObject).boolValue == true {
                        DispatchQueue.main.async(execute: { () -> Void in
                            success(json as! NSDictionary)
                            DataUtils.removeLoadIndicator()
                        })
                    }else {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let dict = NSMutableDictionary()
                            dict.setValue(json!.value(forKey: "message")!, forKey: "errDesc")
                            failure(dict)
                            DataUtils.removeLoadIndicator()
                        })
                    }
                } catch let error1 as NSError {
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure(NSDictionary(object: error1.localizedDescription , forKey: "errDesc" as NSCopying))
                        DataUtils.removeLoadIndicator()
                    })
                    json = nil
                } catch {
                    fatalError()
                }
            }else {
                DispatchQueue.main.async(execute: { () -> Void in
                    failure(NSDictionary(object: (error as! NSError).code == -1009 ? "It seems that you have disconnected from the Internet. Please check your Internet connectivity" : (error as! NSError).localizedDescription , forKey: "errDesc" as NSCopying))
                    DataUtils.removeLoadIndicator()
                })
            }
        }).resume()
        
    }
    
    //MARK:- Request to send images

    
    func imageFromServerURL(_ urlString: String , success:@escaping (UIImage)->Void, failure:@escaping (UIImage)-> Void) ->Void {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error?.localizedDescription ?? "error")
                failure( UIImage())
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                success( image!)
            })
            
        }).resume()
    }

    
    
    //MARK:- Request to send images
    
    func imageUploadRequest(_ urlString:String,headerDict:[String:String], param:NSMutableDictionary?, success:@escaping (NSDictionary)->Void, failure:@escaping (NSDictionary)-> Void) ->Void{
        
        let myUrl = URL(string: urlString)
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headerDict

        let boundary = generateBoundaryString()
        request.allHTTPHeaderFields = headerDict

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("c8a1ad1332716aa15752422360e739a5", forHTTPHeaderField: "public-key")
        request.httpBody = createBodyWithParameters(param, filePathKey: "", paths: [], boundary: boundary)
        DataUtils.addLoadIndicator()
        
        
    
        
        
        
        
       
        
        
        
        
        
        
        
        
        
        
        
        
        let task =  URLSession.shared.dataTask(with: (request as URLRequest),completionHandler: {(data, response, error) -> Void in
            if let data = data {
                
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                print("json value \(json)")
                
                DispatchQueue.main.async(execute: {
                    DataUtils.removeLoadIndicator()
                    success(json! as NSDictionary)
                    DataUtils.removeLoadIndicator()
                    
                });
                
            } else if let error = error {
                print((error as NSError).description)
                DispatchQueue.main.async(execute: {
                    DataUtils.removeLoadIndicator()
                    failure(NSDictionary(object:  (error as NSError).code == -1009 ? "It seems that you have disconnected from the Internet. Please check your Internet connectivity" : (error as NSError).localizedDescription , forKey: "errDesc" as NSCopying))
                    DataUtils.removeLoadIndicator()
                });
            }
        })
        task.resume()
    }
    
    
    func createBodyWithParameters(_ parameters: NSMutableDictionary?, filePathKey: String?, paths: [String]?, boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if paths != nil {
            for path in paths! {
                let url = URL(fileURLWithPath: path)
                let filename = url.lastPathComponent
                let data = try! Data(contentsOf: url)
                let mimetype = mimeTypeForPath(path)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func mimeTypeForPath(_ path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
