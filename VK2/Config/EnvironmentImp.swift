//
//  EnvironmentImp.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 03.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation


struct EnvironmentImp {
    private init(){}
}

extension EnvironmentImp {
    
    struct Debug: Environment {
        let authBaseUrl = URL(string: "https://oauth.vk.com")!
        let baseUrl = URL(string: "https://api.vk.com")!
        var clientId = "6205040"
        var apiVersion = "5.68"
    }
    
}

