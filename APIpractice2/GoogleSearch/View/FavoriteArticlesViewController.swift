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
import Instantiate
import InstantiateStandard

class FavoriteArticlesViewController: UIViewController, StoryboardInstantiatable {
    
    var dataSource = FavoriteArticlesData().favoriteArticle

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        addFavoriteArticle(title: "お気に入り1", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/1/15/Douglas_Squirrel_DSC3742vvc.jpg", articleUrl: "https://en.wikipedia.org/wiki/Douglas_squirrel")
        print(dataSource.count)
        print(dataSource[0].title)
    }
    
    func addFavoriteArticle(title: String, imageUrl: String, articleUrl: String) {
        let newArticle = FavoriteArticlesData.FavoriteArticle(title: title, link: imageUrl, contextLink: articleUrl)
        dataSource += [newArticle]
    }
    

}

extension FavoriteArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        let title = dataSource[indexPath.row].title
        let imageUrl = dataSource[indexPath.row].link
        cell.googleBindData(title: title, imageUrl: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController.instantiate()
        vc.articleTitle = dataSource[indexPath.row].title
        vc.articleUrl = dataSource[indexPath.row].contextLink
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
