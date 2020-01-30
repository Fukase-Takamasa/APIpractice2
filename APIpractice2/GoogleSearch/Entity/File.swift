//
//  File.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation

class BrowsingHistory {
    var browsingHistory: [BrowsedArticle] = [] {
        didSet {
            
        }
    }
    
    class BrowsedArticle {
        var title: String
        var link: String
        var contextLink: String
        
        init(title: String, link: String, contextLink: String) {
            self.title = title
            self.link = link
            self.contextLink = contextLink
        }
    }
}
