//
//  NewsRouter.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 19.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import Alamofire

struct NewsRouter {
    
    private let environment: Environment
    private let token: String
    
    func list() -> URLRequestConvertible {
        return List(environment: environment, token: token)
    }
    
    init(environment: Environment, token: String){
        self.environment = environment
        self.token = token
    }
}

extension NewsRouter {
    
    private struct List: RequestRouter {
        let environment: Environment
        let token: String
        
        init(environment: Environment, token: String) {
            self.environment = environment
            self.token = token
        }
        
        var baseUrl: URL {
            return environment.baseUrl
        }
        
        let method: HTTPMethod = .get
        
        var path = "/method/newsfeed.get"
        
        var parameters: Parameters {
            return [
                "filters": "post,photo",
                "access_token": token,
                "v": environment.apiVersion
            ]
        }
    }
}
