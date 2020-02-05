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
import RxDataSources
import RealmSwift
import Instantiate
import InstantiateStandard

class FavoriteArticlesViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    let viewModel: FavoriteArticleViewModelType = FavoriteArticleViewModel()
    
    let dataSource = RxTableViewSectionedReloadDataSource<FavoriteArticlesDataSource>(configureCell: {(dataSource: TableViewSectionedDataSource<FavoriteArticlesDataSource>, tableView: UITableView, indexPath: IndexPath, item: FavoriteArticles) in
        
    let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        
        print(item)
        let title = item.title
        let imageUrl = item.imageUrl
        cell.googleBindData(title: title, imageUrl: imageUrl)
        cell.favoriteButton.isHidden = true
        print("セルを生成")
        return cell
    })
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        //input
        rx.sentMessage(#selector(viewWillAppear(_:)))
            .bind(to: viewModel.inputs.viewWillAppearTrigger)
            .disposed(by: disposeBag)
        
        //output
        viewModel.outputs.favoriteArticles
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //other
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected((FavoriteArticlesDataSource.Item.self))
            .subscribe(onNext: { [weak self] model in
                let vc = ArticleViewController.instantiate()
                vc.articleTitle = model.title
                vc.articleUrl = model.articleUrl
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}



extension FavoriteArticlesViewController: UITableViewDelegate {
    
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
    
}
