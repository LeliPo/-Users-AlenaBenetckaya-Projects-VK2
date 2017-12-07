//
//  NewsService.swift
//  GBVK
//
//  Created by Алёна Бенецкая on 19.10.2017.
//  Copyright © 2017 Алёна Бенецкая. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NewsService {
    
    private let router: NewsRouter
    private let parser: JsonParser = ParserFactory().newsFeed()
    
    init(environment: Environment, token: String) {
        router = NewsRouter(environment: environment, token: token)
    }
    
    func downloadsNews(completion: @escaping ([New]) -> Void) {
        
        Alamofire.request(router.list()).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data: data)
            let news = self.parser.parse(json) as? [New]
            DispatchQueue.main.async {
                completion(news ?? [])
            }

        }
    }
    
}
