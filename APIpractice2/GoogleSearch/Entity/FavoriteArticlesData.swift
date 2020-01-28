//
//  FavoriteArticlesData.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/28.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation

class FavoriteArticleList {
    var favoriteArticle: [FavoriteArticle] = []
    
    class FavoriteArticle {
        var title: String = ""
        //画像URL
        var link: String = ""
        //記事のURL
        var contextLink: String = ""
    }
}
