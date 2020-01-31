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
    static func addArticleToRealm(title: String, imageUrl: String, articleUrl: String, realmModel: Object) -> Bool {
        let realmModel = realmModel()
        realmModel.title = title
        realmModel.imageUrl = imageUrl
        realmModel.articleUrl = articleUrl
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(realmModel)
                print("RealmFunction: addしました")
                return true
            }
        } catch {
            print("RealmFunction: addできませんでした")
            return false
        }
    }
    
    static func getArticlesFromRealm(realmModel: Object) -> Results<Object> {
        do {
            let realm = try Realm()
            return try realm.objects(realmModel.self)
            print("RealmFunction: データを取得してreturnしました")
        }catch {
            print("RealmFunction: データを取得できませんでした")
            return Results<Object>
        }
    }
}
