//
//  UserRouter.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import Alamofire

struct UserRouter {
    
    private let environment: Environment
    private let token: String
    
    func userList() -> URLRequestConvertible {
        return UserList(environment: environment, token: token)
    }
    
    func userPhotoList(ownerId: Int) -> URLRequestConvertible {
        return UserPhotoList(environment: environment, token: token, ownerId: ownerId)
    }
    
    init(environment: Environment, token: String){
        self.environment = environment
        self.token = token
    }
}

extension UserRouter {
    
    private struct UserList: RequestRouter {
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
        
        var path = "/method/friends.get"
        
        var parameters: Parameters {
            return [
                "access_token": token,
                "v": environment.apiVersion,
                "fields":"nickname,domain,photo_50"
            ]
        }
    }
}

extension UserRouter {

    private struct UserPhotoList: RequestRouter {
        let environment: Environment
        let token: String
        let ownerId: Int
        
        init(environment: Environment, token: String, ownerId: Int) {
            self.environment = environment
            self.token = token
            self.ownerId = ownerId
        }
        
        var baseUrl: URL {
            return environment.baseUrl
        }
        
        var method: HTTPMethod = .get
        
        var path = "/method/photos.getAll"
        
        var parameters: Parameters {
            return [
                "owner_id": ownerId,
                "access_token": token,
                "v": environment.apiVersion,
                "fields":"nickname,domain,photo_50"
            ]
        }
    }
    
}
