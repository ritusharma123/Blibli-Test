//
//  MaterialRecommendationCategoryRequest.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

struct MaterialRecommendationCategoryRequest: MateriallBackendAPIObjectResponse, MateriallBackendAPIURLEncodedRequest {
    
    let clientId: String
    let userId: String
    let sessionId: String
    let categoryId: String
    let count: Int
    let page: Int
    let template: String
    let sortBy: String
    let filter: String
    let pageType: String
    
    init(clientId: String, userId:String, sessionId:String, categoryId:String, count:Int, page:Int, pageType: String, template: String, sortBy: String, filter:String) {
        self.clientId = (clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.userId = (userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.sessionId = (sessionId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.categoryId = (categoryId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.count = count
        self.page = page
        self.pageType = (pageType.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.template = ( template.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.sortBy = (sortBy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.filter = (filter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        print("raj 1 \(clientId) : \(userId) : \(pageType) :\(template) :\(self.count)")

    }
    
    /// Defines the api endpoint to use
    var endpoint: String {
        var urlEndPoint = "api/products/recommendation?clientId=\(clientId)&userId=\(userId)&categoryId=\(categoryId)"
        if count > -1 {
            urlEndPoint = urlEndPoint + "&count=\(count)"
        }
        if count == 8  && count <= -1{
            urlEndPoint = urlEndPoint + "&count=\(8)"
        }
        if page > -1 {
            urlEndPoint = urlEndPoint + "&page=\(page)"
        }
        if sessionId != "" {
            urlEndPoint = urlEndPoint + "&sessionId=\(sessionId)"
        }
        if filter != "" {
            urlEndPoint = urlEndPoint + "&filter=\(filter)"
        }
        urlEndPoint = urlEndPoint + "&pageType=\(pageType)&template=\(template)&sortBy=\(sortBy)"
       print("Endpoint : \(urlEndPoint)")
        
        return URL(string: urlEndPoint)!.absoluteString
    }
    
    // Define what method
    var method: URLRequest.HTTPMethod {
        return .get
    }
}
