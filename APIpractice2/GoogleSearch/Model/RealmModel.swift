//
//  RealmModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/31.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteArticles: Object {
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var articleUrl = ""
}

class BrowsingHistory: Object {
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var articleUrl = ""
}

open class RealmFunction {
    
    static func addFavoriteArticleToRealm(title: String, imageUrl: String, articleUrl: String) {
        let realmModel = FavoriteArticles()
        realmModel.title = title
        realmModel.imageUrl = imageUrl
        realmModel.articleUrl = articleUrl
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(realmModel)
                print("RealmFunction: addしました")
            }
        } catch {
            print("RealmFunction: addできませんでした")
        }
    }
    
    static func addBrowsedArticleToRealm(title: String, imageUrl: String, articleUrl: String) {
        let realmModel = BrowsingHistory()
        realmModel.title = title
        realmModel.imageUrl = imageUrl
        realmModel.articleUrl = articleUrl
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(realmModel)
                print("RealmFunction: addしました")
            }
        } catch {
            print("RealmFunction: addできませんでした")
        }
    }
}
