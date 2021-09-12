//
//  MateriallRecomProductSearchRequest.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

struct MateriallRecomProductSearchRequest: MateriallBackendAPIObjectResponse, MateriallBackendAPIURLEncodedRequest {
    
    let clientId: String
    let searchq: String
    let count: Int
    let page: Int
    let sortBy: String
    let userID: String
    let template: String
    init(clientId: String, userId:String, searchq:String, count:Int, page:Int, sortBy: String, template: String) {
        self.clientId = (clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.userID = (userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.count = count
        self.page = page
        self.searchq = (searchq.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.sortBy = (sortBy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.template = ( template.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        print("## getting from recommended product search category \(clientId) :\(self.userID) : \(self.searchq) :\(self.count)")
    }
    /// Defines the api endpoint to use
    var endpoint: String {
        var urlEndPoint = "api/products/recommendation?clientId=\(clientId)&userId=\(userID)&searchq=\(searchq)"
        if count > -1 {
            urlEndPoint = urlEndPoint + "&count=\(count)"
        }
        if page > -1 {
            urlEndPoint = urlEndPoint + "&page=\(page)"
        }
        if self.template.count > 0 {
            urlEndPoint = urlEndPoint + "&template=\(template)"
        }
        urlEndPoint = urlEndPoint + "&sortBy=\(sortBy)"
       print("Endpoint : \(urlEndPoint)")
        
        return URL(string: urlEndPoint)!.absoluteString
    }
    
    // Define what method
    var method: URLRequest.HTTPMethod {
        return .get
    }
}
