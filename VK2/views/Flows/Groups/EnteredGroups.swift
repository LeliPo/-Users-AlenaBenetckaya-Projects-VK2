//
//  EnteredGroups.swift
//  VK2
//
//  Created by  Алёна Бенецкая on 07.12.2017.
//  Copyright © 2017  Алёна Бенецкая. All rights reserved.
//

import Foundation
struct AuthenticatedUser {
    let id: String
    let enteredGroups: [EnteredGroups]
    
    var toAnyObject: Any {
        return [
            "id": id,
            "enteredGroups": enteredGroups.reduce([Int: Any](),{(prevResult, enteredGroups) in
                var prevResult = prevResult
                prevResult[enteredGroups.groupId] = enteredGroups.toAnyObject
                return prevResult
            })
        ]
    }
}


struct EnteredGroups {
    let groupId: Int
    var toAnyObject: Any {
        return [
            "groupId": groupId
        ]
    }
}
