//
//  MateriallProductEvent.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

struct MateriallProductEvent: MateriallBackendAPIObjectResponse, MateriallBackendAPIURLEncodedRequest {
    
    let clientId: String
    let userID: String
    let sessionId: String
    let categoryId: String
    let type: String
    let pageType: String
    let deviceType: String
    let deviceOS: String
    let browser: String
    let searchq: String
    let page: Int
    let ratings: String
    init(clientId: String, userId:String, sessionId:String, categoryId:String,type:String, pageType: String, devicetype: String, deviceos:String, Browser: String, PageType: String, SearchQ: String,page: Int, Ratings: String) {
        self.clientId = (clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.userID = (userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.sessionId = (sessionId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.categoryId = (categoryId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.type = (type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.pageType = (pageType.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.deviceType = (devicetype.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.deviceOS = (deviceos.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.browser = (Browser.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.searchq = (SearchQ.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.page = page
        self.ratings = (Ratings.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        print("## getting from  product  event \(clientId) :\(self.userID) : \(self.clientId)")
    }

    /// Defines the api endpoint to use
    var endpoint: String {
        var urlEndPoint = "api/user/\(userID)/event?type=\(type)&clientId=\(clientId)&sessionId=\(sessionId)"
      
        if pageType == "categoryPage"{
            urlEndPoint = urlEndPoint + "&categoryID=\(categoryId)"
        }
        if pageType == "searchPage"{
            urlEndPoint = urlEndPoint + "&searchq=\(self.searchq)"
        }
        if type == "rate"{
            urlEndPoint = urlEndPoint + "&ratings=\(self.ratings)"
        }
        urlEndPoint = urlEndPoint + "&pageType=\(pageType)&deviceType=\(deviceType)&deviceOS=\(deviceOS)&browser=\(browser)&page=\(page)"

        
      
       print("Endpoint : \(urlEndPoint)")
        
        return URL(string: urlEndPoint)!.absoluteString
    }
    
    // Define what method
    var method: URLRequest.HTTPMethod {
        return .post
    }
}

