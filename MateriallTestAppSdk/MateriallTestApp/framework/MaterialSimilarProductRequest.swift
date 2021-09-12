//
//  MaterialSimilarProductRequest.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

struct MaterialSimilarProductRequest: MateriallBackendAPIObjectResponse, MateriallBackendAPIURLEncodedRequest {
    
    let clientId: String
    let productId: String
    let categoryId: String
    let count: Int
    let page: Int
    let template: String
    let userID: String
    let filter: String
    init(clientId: String, userId:String, productId:String,categoryId:String, count:Int,template:String, page: Int, filter: String) {
        self.clientId = (clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.userID = (userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.count = count
        self.page = page
        self.productId = (productId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.categoryId = (categoryId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.template = (template.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        self.filter = (filter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        print("## getting from recommended product search category \(clientId) :\(self.userID) : \(self.productId)")
    }
    /// Defines the api endpoint to use
    var endpoint: String {
        var urlEndPoint = "api/product/\(productId)/similar/recommendations?clientId=\(clientId)&userId=\(userID)&categoryId=\(categoryId)"
        if count > -1 {
            urlEndPoint = urlEndPoint + "&count=\(count)"
        }
      
        if filter.count > 0 {
            urlEndPoint = urlEndPoint + "&filter=\(filter)"
        }
     
        urlEndPoint = urlEndPoint + "&template=\(template)"
       print("Endpoint : \(urlEndPoint)")
        
        return URL(string: urlEndPoint)!.absoluteString
    }
    
    // Define what method
    var method: URLRequest.HTTPMethod {
        return .get
    }
}
