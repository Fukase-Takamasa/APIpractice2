//
//  FavoriteArticlesViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/22.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Instantiate
import InstantiateStandard

class FavoriteArticlesViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    
    var favoriteArticlesList: Results<FavoriteArticles>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        
                //Realmに保存されているデータを取得する処理
//         do {
//             let realm = try Realm()
//             favoriteArticlesList = realm.objects(FavoriteArticles.self)
//             print("realm.objectsの中身: \(realm.objects(FavoriteArticles.self))")
//         }catch {
//             print("RealmFunction: データを取得できませんでした")
//         }
//
//
//         //↓で取得したURLの使い方
//         //RealmBrowser開いて、open file→　command + shift + Gでパス入力フォームを表示してから、 取得したURLのfile://より後ろだけを貼り付け。
//         print("Realmの保存先URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        
    }
    
}



extension FavoriteArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
//        let title = dataModel.dataList[indexPath.row].title
//        let imageUrl = dataModel.dataList[indexPath.row].link
//        cell.googleBindData(title: title, imageUrl: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ArticleViewController.instantiate()
//        vc.articleTitle = dataModel.dataList[indexPath.row].title
//        vc.articleUrl = dataModel.dataList[indexPath.row].image.contextLink
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
