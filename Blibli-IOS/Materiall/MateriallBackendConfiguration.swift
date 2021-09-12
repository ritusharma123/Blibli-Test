//
//  MateriallBackendConfiguration.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

public final class MateriallBackendConfiguration {
    
    let baseURL: URL?
    
    var apiAuthenticator: BackendAPIAuth?
    
    public init() {
        self.baseURL = .none
    }
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    convenience public init(baseURL: URL, apiAuth: BackendAPIAuth) {
        self.init(baseURL: baseURL)
        self.apiAuthenticator = apiAuth
    }
    
    public func updateDefault() {
        MateriallBackendConfiguration.shared = self
    }
    
    static var shared = MateriallBackendConfiguration()
}

public class MateriallBackendService {
    
    /// the backend configuration
    private let configuration: MateriallBackendConfiguration
    public var body: Data?
    /// the service to connect
    private var services: [MateriallNetworkService] = []
    
    private var workingQueue = DispatchQueue(label: "com.materiall.framework.network")
    
    internal var onAllTaskFinished: (() -> ())?
    
    init(configuration: MateriallBackendConfiguration? = .none) {
        self.configuration = configuration ?? MateriallBackendConfiguration.shared
    }
    
    /// Start a request to the configured server with the given request
    ///
    /// - Parameters:
    ///   - request: the request to start
    ///   - success: success callback
    ///   - failure: failure callback
    func request(_ request: MateriallBackendAPIRequest, timeout: MaterialNetworkTimeout = .long,
                 success: ((Any) -> Void)? = nil,
                 failure: (([String: Any]?, MateriallNetworkServiceError, Int) -> Void)? = nil,
                 progress: ((Float)->())? = nil) {
        // Configure URL
        let urlstring = (configuration.baseURL?.appendingPathComponent(request.endpoint).absoluteString.removingPercentEncoding)!
        let serviceURL = URL(string: urlstring)
        print("url - \(String(describing: serviceURL))")
        guard let url = serviceURL
            else {
                failure?(.none, .wrongURL, 0)
                return
        }
        let completeUrl: URL

       
        if let urlEncodedRequest = request as? MateriallBackendAPIURLEncodedRequest {
            // Configure parameters
            if urlEncodedRequest.parameters.count > 0 {
                // creating the query string
                let getParameters = urlEncodedRequest.parameters.map() { "\($0)=\($1)" }
                let queryString = getParameters.joined(separator: "&")
                
                switch urlEncodedRequest.method {
                case .get, .delete, .head:
                    // including GET parameters directly in URL
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    components?.query = queryString
                    completeUrl = components?.url ?? url
                    body = .none
                   
                case .post, .put:
                    // including parameters in body, as x-www-form-urlencoded
                    completeUrl = url
                    body = queryString.data(using: String.Encoding.utf8)
                }
            }
            else {
                completeUrl = url
                body = .none
                
            }
        }
        else if let jsonRequest = request as? MateriallBackendAPIRawJSONRequest {
            completeUrl = url
            
            body = try? JSONSerialization.data(withJSONObject: jsonRequest.jsonObject, options: [])
        }
        else {
            completeUrl = url
            body = .none
           
        }
        
        // Configure headers
        var headers = request.headers
        if let authHeaders = configuration.apiAuthenticator?.authenticationHeader(withUrl: completeUrl) {
            // adds auth headers into headers
            authHeaders.forEach { _ = headers?.updateValue($1, forKey: $0) }
        }
        
        let service = MateriallNetworkService()
        self.workingQueue.async {
            self.services.append(service)
        }
        print("Response body \(String(describing: body))")
        service.request(url: completeUrl, method: request.method, timeout: timeout, body: body, headers: headers, success: { data in
            // The request is a BackendAPIObjectResponse (some json)
            if request is MateriallBackendAPIObjectResponse {
                
                      guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let dic = json as? [String: Any]
                      //let objectDic = dic[request.objectKey]
                    
                    else {
                    DispatchQueue.main.async {
                    
                        //failure?(.none, .unreadableResponse, 0)
                    }
                    return
                }
                DispatchQueue.main.async {
                    success?(dic)
                  
                }
            }
            else {
                print("Unknown Response \( String(describing: try? JSONSerialization.jsonObject(with: data!, options: [])) )")
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    DispatchQueue.main.async {
                        failure?(.none, .unreadableResponse, 0)
                    }
                    return
                }
                DispatchQueue.main.async {
                    success?(json)
                   
                }
            }
            self.closeService(service)
            
        }, failure: { data, error, statusCode in
           
            var json: Any? = .none
            if let data = data {
                json = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            DispatchQueue.main.async {
                failure?(json as? [String: Any], error, statusCode)
            }
            self.closeService(service)
        }, progress: progress)
    }
    /// Cancels the current tasks
    func cancel() {
        self.workingQueue.async {
            self.services.forEach { $0.cancel() }
            self.services.removeAll()
        }
    }
    
    /// Closes a finished service
    ///
    /// - Parameter service: the finished service
    private func closeService(_ service: MateriallNetworkService) {
        self.workingQueue.async {
            guard let index = self.services.firstIndex(of: service) else { return }
            self.services.remove(at: index)
            if self.services.count == 0 {
                DispatchQueue.main.async {
                    self.onAllTaskFinished?()
                }
            }
        }
    }
}

/// Handles API authentication by creating key-value pairs used as request headers
public protocol BackendAPIAuth {
    
    /// Generates authentication header with the given URL
    ///
    /// - Parameter url: the url to call
    /// - Returns: some key-value pairs, to use in header
    func authenticationHeader(withUrl url: URL) -> [String: String]
}
