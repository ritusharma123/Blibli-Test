//
//  MateriallNetworkService.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation
import MobileCoreServices

extension URLRequest {
    
    internal enum HTTPMethod: String {
        case get
        case post
        case put
        case delete
        case head
    }
    
    var method: HTTPMethod? {
        get {
            guard let httpMethod = self.httpMethod else { return nil }
            switch httpMethod {
            case "GET":
                return .get
            case "POST":
                return .post
            case "PUT":
                return .put
            case "DELETE":
                return .delete
            case "HEAD":
                return .head
            default:
                return nil
            }
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}

public typealias MateriallServiceResult<T> = Result<T, MateriallNetworkServiceError>

/// Error produced by framework API calls
public enum MateriallNetworkServiceError: Error {
    // before request
    case cannotCreateRequestBody
    case wrongURL
    
    // after request
    case timeout
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case alreadyExists
    case unknownError(Int)
    case unreadableResponse
    
    internal init(statusCode: Int) {
        switch statusCode {
        case 0:
            self = .timeout
        case .badRequest:
            self = .badRequest
        case .unauthorized:
            self = .unauthorized
        case .forbidden:
            self = .forbidden
        case .notFound:
            self = .notFound
        case .alreadyExists:
            self = .alreadyExists
        default:
            self = .unknownError(statusCode)
        }
    }
}

/// some http error codes
internal extension Int {
    static let badRequest = 400
    static let unauthorized = 401
    static let forbidden = 403
    static let notFound = 404
    static let alreadyExists = 409
}

internal enum MaterialNetworkTimeout {
    case short
    case standard
    case long
    case verylong
    case custom(TimeInterval)
    
    var interval: TimeInterval {
        switch self {
        case .short: return 5
        case .standard: return 10
        case .long: return 30
        case .verylong: return 60
        case .custom(let t): return t
        }
    }
}

internal class MateriallNetworkService: NSObject {
    
    private var task: URLSessionDataTask?
    private let successCodes: Range<Int> = 200..<299
    private let failureCodes: Range<Int> = 400..<599
    internal var timeout: MaterialNetworkTimeout = .standard
    
    private var session: URLSession?
    
    /// Execute a REST request with the given parameters
    ///
    /// - Parameters:
    ///   - url: the server url
    ///   - method: a method
    ///   - params: the parameters to send
    ///   - headers: some headers
    ///   - success: closure to call on success
    ///   - failure: closure to call on failure
    public func request(url: URL, method: URLRequest.HTTPMethod,
                 timeout: MaterialNetworkTimeout = .standard,
                 body: Data? = .none,
                 headers: [String: String]? = .none,
                 success: ((Data?) -> Void)? = .none,
                 failure: ((Data?, MateriallNetworkServiceError, Int) -> Void)? = .none,
                 progress: ((Float)->())? = .none) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout.interval)
        request.allHTTPHeaderFields = headers
        request.method = method
        request.httpBody = body
        print("body1 \(body)")

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.callbacks = (.none, progress, .none)
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        self.task = self.session?.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let wself = self else { return }
            
            if let httpResponse = response as? HTTPURLResponse {
                // Log the serveur response
                //                if let unwrappedData = data, let responseString = String(data: unwrappedData, encoding: String.Encoding.utf8) {
                //                    print("\n\(httpResponse.statusCode)\n\(responseString)")
                //                }
                
                if wself.successCodes.contains(httpResponse.statusCode) {
                    success? (data)
                }
                else if wself.failureCodes.contains(httpResponse.statusCode) {
                    let e = MateriallNetworkServiceError(statusCode: httpResponse.statusCode)
                    failure? (data, e, httpResponse.statusCode)
                }
            }
            else {
                let e = MateriallNetworkServiceError.unknownError(0)
                failure? (data, e, 0)
            }
            self?.callbacks = nil
            self?.session?.finishTasksAndInvalidate()
        })
        NSLog("[%@] %@", method.rawValue, url.absoluteString)
        self.task?.resume()
    }
    
    /// saved callbacks used for upload requests. Upload tack only works with delegate.
    private var callbacks: (success: ((Data) -> ())?, progress: ((Float) -> ())?,    failure: ((Error, Int) -> ())?)?
 
    func cancel() {
        self.task?.cancel()
        self.session?.invalidateAndCancel()
        self.callbacks = nil
    }
}


// MARK: - URLSessionTaskDelegate
/// For handling upload requests
extension MateriallNetworkService: URLSessionDataDelegate {
    
    // On complete
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let httpResponse = task.response as? HTTPURLResponse
        if let error = error {
            // Failed
            self.callbacks?.failure?(error, httpResponse?.statusCode ?? 0)
            self.callbacks = nil
            session.finishTasksAndInvalidate()
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // No error
        self.callbacks?.success?(data)
        self.callbacks = nil
        session.finishTasksAndInvalidate()
    }
    
    // On progress
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        self.callbacks?.progress?(Float(totalBytesSent)/Float(totalBytesExpectedToSend))
    }
}
