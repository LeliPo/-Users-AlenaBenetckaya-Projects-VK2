//
//  GroupService.swift
//  VK2
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

struct GroupService {
    private let router: GroupRouter
    
    init(environment: Environment, token: String) {
        router = GroupRouter(environment: environment, token: token)
    }
    
    func dowloadGroups() {
        Alamofire.request(router.groupList()).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let groups = json["response"]["items"].array?.flatMap { Group(json: $0) } ?? []
            Realm.replaceAllObjectOfType(toNewObjects: groups)
        }
    }
    
    func loadGroups() -> [Group] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Group.self))
        } catch {
            print(error)
            return []
        }
    }
    
    func searchGroups(request: String, completion: @escaping ([Group]) -> () ) {
        Alamofire.request(router.searchGroup(request: request)).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let groupsId = json["response"]["items"].array?.flatMap { String(describing: $0["id"].intValue) }.joined(separator: ",") ?? ""
            DispatchQueue.main.async {
            self.groupInfo(bygGoupsId: groupsId, completion: completion)
            }
        }
    }
    
    private func groupInfo(bygGoupsId groupsId: String, completion: @escaping ([Group]) -> () ) {
        Alamofire.request(router.groupInfo(groupsID: groupsId)).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let groups = json["response"].array?.flatMap { Group(json: $0) } ?? []
            DispatchQueue.main.async {
            completion(groups)
            }
        }
    }
    
    func joinToGroup(groupID: Int, completion: @escaping () -> () ) {
        Alamofire.request(router.joinToGroup(groupID: groupID)).responseData(queue: .global(qos: .userInteractive)) { response in
            DispatchQueue.main.async {
            completion()
            }
        }
    }
    
    func leaveFromGroup(groupID: Int, completion: @escaping () -> () ) {
        Alamofire.request(router.leaveFromGroup(groupID: groupID)).responseData(queue: .global(qos: .userInteractive)) { response in
            DispatchQueue.main.async {
            completion()
            }
        }
    }
    
}
