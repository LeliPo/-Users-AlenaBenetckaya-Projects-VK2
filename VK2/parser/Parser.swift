//
//  NewParcer.swift
//  VK2
//
//  Created by Алёна Бенецкая on 19.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonParser {
    func parse(_ json: JSON) -> [AnyObject]
}
