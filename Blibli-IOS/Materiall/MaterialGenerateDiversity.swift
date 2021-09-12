//
//  MaterialGenerateDiversity.swift
//  Materiall
//
//  Created by Prasenjit Das on 16/03/21.
//

import Foundation

struct MaterialGenerateDiversity: MateriallBackendAPIObjectResponse, MateriallBackendAPIURLEncodedRequest {
    
    let clientId: String
   
    init(clientId: String) {
        self.clientId = (clientId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
     
        print("## getting from  product  event \(clientId)")
    }
    /// Defines the api endpoint to use
    var endpoint: String {
        var urlEndPoint = "api/compute/diverse"
      
        if clientId != "" {
            urlEndPoint = urlEndPoint + "?clientId=\(clientId)"
        }
      
       print("Endpoint : \(urlEndPoint)")
        
        return URL(string: urlEndPoint)!.absoluteString
    }
    
    // Define what method
    var method: URLRequest.HTTPMethod {
        return .get
    }
}
