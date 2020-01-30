//
//  File.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import Foundation

struct browsingHistoryData {
    var items:[Items]
    
    struct Items: Codable {
        //タイトル
        var title: String
        //画像のURL（リクエストパラメータでsearchTypeをimageに指定していると"link"に記事URLではなく画像のURLが返ってくる。
        var link: String
        //記事のURL
        var image: Url
        
        struct Url: Codable {
            var contextLink: String
        }
    }
}

//struct BrowsingHistoryData {
//        var title: String
//        var link: String
//        var contextLink: String
    
//    init(title: String, link: String, contextLink: String) {
//        self.title = title
//        self.link = link
//        self.contextLink = contextLink
//    }
//}

