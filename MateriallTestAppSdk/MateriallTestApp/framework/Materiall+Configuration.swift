//
//  Materiall+Configuration.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation
import CoreData

extension Materiall {
    struct Configuration {
        
        init() {
        }
        
        func webServicesBaseURL(for environment: Environment) -> URL {
            switch environment {
            case .local:
                return URL(string: "http://localhost:8888/")!
            case .QA:
                return URL(string: "https://blibli-qa.curiosearch.in")!
            case .development:
                return URL(string: "https://api.blibli-staging.curiosearch.in")!
            case .production:
                return URL(string: "https://blibli-qa.curiosearch.in")!
            case .custom(let url):
                return url
            }
        }
        
        /// default Blibli test server
        //let defaultServerUrl = URL(string: "blibli-qa.curiosearch.in")!
        
    }
}

