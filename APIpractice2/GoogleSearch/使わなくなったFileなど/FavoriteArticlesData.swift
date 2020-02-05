//
//  FavoriteArticlesData.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/28.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//
//
//import Foundation
//
//class FavoriteArticlesData {
//    var favoriteArticle: [FavoriteArticle] = [] {
//        didSet {
//            print("data:閲覧履歴が追加されました。")
//            let vc = FavoriteArticlesViewController.instantiate()
//            vc.tableView.reloadData()
//        }
//    }
//    
//    class FavoriteArticle {
//        var title: String
//        //画像URL
//        var link: String
//        //記事のURL
//        var contextLink: String
//        
//        init(title: String, link: String, contextLink: String) {
//            self.title = title
//            self.link = link
//            self.contextLink = contextLink
//        }
//    }
//}
