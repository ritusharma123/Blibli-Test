//
//  Materiall.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

public class Materiall {
    
    
    /// The framework API environment
    ///
    /// - local: server is localhost
    /// - development: online development server
    /// - production: production server
    public enum Environment {
        case local
        case development
        case production
        case QA
        case custom(URL)
    }
    
    /// Framework main accessor
    public static let framework = Materiall()
    
    /// Defines the environment to use
    public var environment: Environment = .production
    
    /// configuration object that contains dynamic or static properties
    internal var configuration = Configuration()
    
    /// The operation queue on which initialisation stuff should be made
    private let queue: OperationQueue = OperationQueue()
    
    ///Parameter list for API calls
    /// Get recommended products for a product category
    private var count: Int = -1
    private var page: Int = 0
    private var meteriall: Bool = true
    private var template: String = "default"
    private var sortBy: String = "Relevance"
    private var sessionId: String = ""
    private var categoryID: String = ""
    private var clientID: String = ""
    private var filter: String = ""
    private var pageType: String = ""
    private var ratings: String = ""
    private var searchq: String = ""
    private var authorizationToken: String = ""
    private var xRrequestId: String = ""
    init() {
        queue.maxConcurrentOperationCount = 1
       
        
    }
    
    deinit {
        
    }
    public func authenticate(){
        let serviceConfiguration = MateriallBackendConfiguration(baseURL: self.configuration.webServicesBaseURL(for: self.environment))
        serviceConfiguration.updateDefault()
    }
    public func setCount(value: Int){
        count = value
    }
    public func setPage(value: Int){
        page = value
    }
    public func setMeteriall(value: Bool){
        meteriall = value
    }
    public func setTemplate(value: String){
        template = value
    }
    public func setSortBy(value: String){
        sortBy = value
    }
    public func setSessionID(value: String){
        sessionId = value
    }
    public func setCategoryID(value: String){
        categoryID = value
    }
    public func setClientID(value: String){
        clientID = value
    }
    public func setFilter(value: String){
        filter = value
    }
    
    public func setPageType(value: String){
        pageType = value
    }
    public func setRating(value: String){
        ratings = value
    }
    public func setSearchQuery(value: String){
        searchq = value
    }
    public func setAuthorizationToken(value: String){
        authorizationToken = value
    }
    
    public func setXRequestID(value: String){
        xRrequestId = value
    }
    
    ///authentication token generate using base64
    
    public func authorizationTokenGenerate(ClienID:String) {
        TimeService.getCurrentUnixTimeStamp { timeInterval in
            //let timeInterval = NSDate().timeIntervalSince1970
            print(Int(timeInterval) )
            let str = "cid_\(ClienID)/ct_\(Int64((timeInterval) * 1000))"
            print("Original: \(str)")
            let utf8str = str.data(using: .utf8)

            if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                print("Encoded: \(base64Encoded)")
                self.authorizationToken =  base64Encoded
            }
        }
        
       
        
    }
    
    public func getRecommendedProductCategory(clientID: String?,userID: String?, sessionId: String?,page:Int, pagetype:String,template:String, then: @escaping ([String: Any]) -> ()) {
        let semaphore = DispatchSemaphore (value: 0)
        //print("raaj 2\(authorizationToken)")
        var endpoint: String {
            var urlEndPoint = "api/products/recommendation?&clientId=\(clientID ?? "")&sessionId=\(sessionId ?? "")&userId=\(userID ?? "")&page=\(page)&pageType=\(pagetype)&template=\(template)"

            if filter != "" {
               let filterData = (filter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                urlEndPoint = urlEndPoint + "&filter=\(filterData)"
            }
            if pagetype == "categoryPage"{
                urlEndPoint = urlEndPoint + "&categoryID=\(self.categoryID)"
            }
            if pagetype == "searchPage"{
                let searchKey = (searchq.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                urlEndPoint = urlEndPoint + "&searchq=\(searchKey)"
            }
            if count > -1 {
                urlEndPoint = urlEndPoint + "&count=\(count)"
            }
            if count == 8  && count <= -1{
                urlEndPoint = urlEndPoint + "&count=\(8)"
            }
            if sortBy == ""{
                setSortBy(value: "Relevance")
            }
            urlEndPoint = urlEndPoint + "&sortBy=\(sortBy)"
           print("Endpoint : \(urlEndPoint)")
            
            return URL(string: urlEndPoint)!.absoluteString
        }
        let urlstring = ( MateriallBackendConfiguration.shared.baseURL?.appendingPathComponent(endpoint).absoluteString.removingPercentEncoding)!
        print("\(urlstring)")
        
        var request = URLRequest(url: URL(string: urlstring)!,timeoutInterval: Double.infinity)
        request.addValue(authorizationToken, forHTTPHeaderField: "Authorization")
        request.addValue(xRrequestId, forHTTPHeaderField: "X-Request-ID")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data
                  
            else {
              print(String(describing: error))
              semaphore.signal()
              then([:])
              print("error")
              return
            }
              let json = try? JSONSerialization.jsonObject(with: data, options: [])
              let dic = json as? [String: Any]

              then(dic ?? [:])
            semaphore.signal()
          }

        task.resume()
        semaphore.wait()

    }
    
    /////Get recommended products for a product category API
//    public func getRecommendedProductCategory(clientId: String?, userId: String?, categoryId: String?, pageType: String,sessionId: String,template:String,page: Int, then: @escaping ([String: Any])-> ()){
//        let service = MateriallBackendService(configuration: MateriallBackendConfiguration.shared)
//        self.queue.addOperation(MateriallAsyncBlockOperation(){ complete in
//            print("## getting from recommended product category \(self.count)")
//            print("raj \(clientId) : \(userId) : \(pageType) :\(template) :\(self.count)")
//            service.request(MaterialRecommendationCategoryRequest(clientId: (clientId ?? ""), userId: (userId ?? ""), sessionId:sessionId, categoryId: (categoryId ?? ""), count: self.count, page: page, pageType: pageType, template: template, sortBy: self.sortBy,filter: self.filter), success: { response in
//                do {
//                    let dic = response as! [String: Any]
//
//                    then(dic)
//                    complete()
//                }
//                catch let error {
//                    print("# Recommendation product downloaded, but cannot map json file.", error)
//                    then([:])
//                    complete()
//                }
//            }, failure: { _, error, _ in
//                print("# recommendation product download failure: \(error)")
//                then([:])
//                complete()
//            })
//        })
//
//    }

    ////Record user actions performed on a product listing
    public func recordUserActions(parameter:Data, clientID: String?,userID: String?, sessionId: String?,type: String?,deviceType:String,deviceOS:String, browser:String,pagetype:String,page:Int, then: @escaping ([String: Any]) -> ()) {
        let semaphore = DispatchSemaphore (value: 0)
       
        var endpoint: String {
            var urlEndPoint = "api/user/\(userID ?? "")/event?type=\(type ?? "")&clientId=\(clientID ?? "")&sessionId=\(sessionId ?? "")"
          
            print(pagetype, pagetype == "categoryPage" )
            if pagetype == "categoryPage"{
                urlEndPoint = urlEndPoint + "&categoryID=\(self.categoryID)"
            }
            if pagetype == "searchPage"{
                urlEndPoint = urlEndPoint + "&searchq=\(self.searchq)"
            }
            if type == "rate"{
                urlEndPoint = urlEndPoint + "&ratings=\(self.ratings)"
            }
            urlEndPoint = urlEndPoint + "&pageType=\(pagetype)&deviceType=\(deviceType)&deviceOS=\(deviceOS)&browser=\(browser)&page=\(page)"

            
          
           print("Endpoint : \(urlEndPoint)")
            
            return URL(string: urlEndPoint)!.absoluteString
        }
        
        let urlstring = ( MateriallBackendConfiguration.shared.baseURL?.appendingPathComponent(endpoint).absoluteString.removingPercentEncoding)!
        print("\(urlstring)")
        
        var request = URLRequest(url: URL(string: urlstring)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authorizationToken, forHTTPHeaderField: "Authorization")
        request.addValue(xRrequestId, forHTTPHeaderField: "X-Request-ID")
        request.httpMethod = "POST"
        request.httpBody = parameter
print(authorizationToken,xRrequestId)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data
                
          else {
            print(String(describing: error))
            semaphore.signal()
            then([:])
            print("error")
            return
          }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let dic = json as? [String: Any]

            then(dic ?? [:])
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }



}
