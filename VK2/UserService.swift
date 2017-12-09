//
//  UserService.swift
//  VK2
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

struct UserService {
    
    private let router: UserRouter
    
    init(environment: Environment, token: String) {
        router = UserRouter(environment: environment, token: token)
    }
    
    func dowloadFriends() {
        Alamofire.request(router.userList()).responseData(queue: .global(qos: .userInteractive))
        { response in
            
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let users = json["response"]["items"].array?.flatMap { User(json: $0) } ?? []
            DispatchQueue.main.async {
            Realm.replaceAllObjectOfType(toNewObjects: users)
            }
        }
            
    }
    
    func downloadPhoto(forUser user: Int, completion: @escaping ([Photo]) -> Void) {
        Alamofire.request(router.userPhotoList(ownerId: user)).responseData(queue: .global(qos: .userInteractive))
        { response in
            
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let photos = json["response"]["items"].array?.flatMap { Photo(json: $0) } ?? []
            DispatchQueue.main.async {
            completion(photos)
            }
        }
    }
    
    func loadFriends() -> [User] {
        do {
            let realm = try Realm()
            return Array(realm.objects(User.self))
        } catch {
            print(error)
            return []
        }
    }
    
    
}
