//
//  TimeService.swift
//  Materiall
//
//  Created by Ritu on 10/09/21.
//

import Foundation

class TimeService{
    
    static func getCurrentUnixTimeStamp(completion:  @escaping (Double) -> ()) {
            var data: Data?
            var error: Error?
            let url = URL(string: "https://worldtimeapi.org/api/ip")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let semaphore = DispatchSemaphore(value: 0)
            let dataTask = URLSession.shared.dataTask(with: request) {
                data = $0
                error = $2
                semaphore.signal()
            }
            dataTask.resume()
            _ = semaphore.wait(timeout: .distantFuture)
            print(error ?? "No error")
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                if let time = json["unixtime"] as? Int{
                    completion(Double(time))
                }else{
                    completion(NSDate().timeIntervalSince1970)
                }
            }catch let err as NSError{
                completion(NSDate().timeIntervalSince1970)
                print(err)
            }
        
    }
    
}
