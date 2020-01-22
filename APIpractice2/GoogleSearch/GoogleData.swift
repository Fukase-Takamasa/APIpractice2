//
//  GoogleData.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Foundation

//Google画像検索APIの取得データをパースするための構造体
struct GoogleData: Codable {
    var items:[Items]
    
    struct Items: Codable {
        //タイトル
        var title: String
        //画像のURL
        var link: String
    }
}
