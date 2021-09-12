//
//  MateriallBackendAPIRequest.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

////////////////////////////////////////////////////////////////////////////
// MARK: Protocols that handle requests
////////////////////////////////////////////////////////////////////////////

protocol MateriallBackendAPIRequest {
    
    /// Defines the api endpoint to use
    var endpoint: String { get }
    
    // Define what method
    var method: URLRequest.HTTPMethod { get }
    
    // Some headers
    var headers: [String: String]? { get }
}

protocol MateriallBackendAPIURLEncodedRequest: MateriallBackendAPIRequest {
    
    // The parameters to pass in
    var parameters: [String: Any] { get }
}

extension MateriallBackendAPIURLEncodedRequest {
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var headers: [String: String]? {
        get {
            return ["Content-Type": "application/json"]
        }
    }
}

protocol MateriallBackendAPIRawJSONRequest: MateriallBackendAPIRequest {
    
    // The JSON parameter
    var jsonObject: [String: Any] { get }
}

extension MateriallBackendAPIRawJSONRequest {
    
    var headers: [String: String]? {
        get {
            return ["Content-Type": "application/json"]
        }
    }
}

protocol MateriallBackendAPIUploadRequest: MateriallBackendAPIRequest {
    
    var boundary: String { get }
    
    /// The file url list to upload
    var fileUrls: [URL] { get }
    
    /// The files common mime type
    var mimeType: String { get }
}

extension MateriallBackendAPIUploadRequest {
    
    var boundary: String { return "com.materiall.framework.uploadboundary" }
    
    var headers: [String: String]? {
        get {
            return ["Content-Type": "multipart/form-data; boundary=\(self.boundary)"]
        }
    }
}

////////////////////////////////////////////////////////////////////////////
// MARK: Protocols that handle responses
////////////////////////////////////////////////////////////////////////////

/// A request with a json object at root named with objectKey property
protocol MateriallBackendAPIObjectResponse {
    // returned object key
    var objectKey: String { get }
}

extension MateriallBackendAPIObjectResponse {
    var objectKey: String {
        get {
            return ""
        }
    }
}
