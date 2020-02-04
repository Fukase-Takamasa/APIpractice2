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
    let viewModel: FavoriteArticleViewModelType = FavoriteArticleViewModel()
    
    var favoriteArticlesList: [FavoriteArticles]?
    //var favoriteArticlesList: Results<FavoriteArticles>?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        //input
        rx.sentMessage(#selector(viewWillAppear(_:)))
            .subscribe(onNext: { element in
                
            })
            
//            .bind(to: viewModel.inputs.viewWillAppearTrigger)
//            .disposed(by: disposeBag)
        
        
        //            .subscribe(onNext: { event in
        //                viewModel.inputs.viewWillAppearTrigger
        //            })
        
            
        
        //output
//        Observable.just(())
//            .withLatestFrom(viewModel.outputs.favoriteArticles)
//            .subscribe(onNext: { element in
//                for data in element {
//                    self.favoriteArticlesList? += [data]
//                }
//            }).disposed(by: disposeBag)
        
            
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
        return favoriteArticlesList?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        guard let title = favoriteArticlesList?[indexPath.row].title, let imageUrl = favoriteArticlesList?[indexPath.row].imageUrl else {
            return cell
        }
        
        
        cell.googleBindData(title: title, imageUrl: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController.instantiate()
        vc.articleTitle = favoriteArticlesList?[indexPath.row].title
        vc.articleUrl = favoriteArticlesList?[indexPath.row].articleUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
