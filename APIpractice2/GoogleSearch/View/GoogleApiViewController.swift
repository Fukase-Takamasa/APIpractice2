//
//  GoogleAPIViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/04.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import Foundation
import Moya
import RxSwift
import RxCocoa
import RxDataSources
import Instantiate
import InstantiateStandard

class GoogleApiViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    let viewModel: GoogleViewModelType = GoogleViewModel()
    let historyViewModel: BrowsingHistoryViewModelType = BrowsingHistoryViewModel()
    
    let browsingHistoryVC = BrowsingHistoryViewController.instantiate()
    
    var favoriteArticleList = FavoriteArticlesData().favoriteArticle
    
    let dataSource = RxTableViewSectionedReloadDataSource<GoogleDataSource>(configureCell: {
    dataSource, tableView, indexPath, item in
    let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath)
    as! GoogleApiCell
    print(item)
    let title = item.title
    let imageUrl = item.link
    print(indexPath)
    cell.googleBindData(title: title, imageUrl: imageUrl)
    //cell.googleBindTitle(title: title)
    print("セルを生成")
    return cell
    })
    
    //var startIndex = 1
    //var pageIndex = 0
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        searchTextField?.delegate = self
        
        //input
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.searchQueryText)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.inputs.searchButtonTapped)
            .disposed(by: disposeBag)
        
        //output
        viewModel.outputs.articles
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //other
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected((GoogleDataSource.Item.self))
            .bind(to: historyViewModel.inputs.cellModelData)
            .disposed(by: disposeBag)
        
         //   .subscribe(onNext: { [weak self] model in
         //       self?.addBrowsingHistory(title: model.title, imageUrl: model.link, articleUrl: model.image.contextLink)
         //       print("VC:閲覧履歴に追加しました。")
         //       print("browsingHistoryVC.dataSource.itemsの中身: \(self?.browsingHistoryVC.dataSource.items)")
         //       let vc = ArticleViewController.instantiate()
         //       print("modelの中身: \(model)")
         //       vc.articleTitle = model.title
         //       vc.articleUrl = model.image.contextLink
         //       self?.navigationController?.pushViewController(vc, animated: true)
         //   }).disposed(by: disposeBag)

    }
    
    func addFavoriteArticle(title: String, imageUrl: String, articleUrl: String) {
        let newArticle = FavoriteArticlesData.FavoriteArticle(title: title, link: imageUrl, contextLink: articleUrl)
        favoriteArticleList += [newArticle]
    }
    
    //func addBrowsingHistory(title: String, imageUrl: String, articleUrl: String) {
    //    let newArticle = BrowsingHistoryData(title: title, link: imageUrl, contextLink: articleUrl)
    //    browsingHistoryVC.dataSource.items += [newArticle]
    //    print("browsingHistoryVC.dataSource.itemsの中身: \(browsingHistoryVC.dataSource.items)")
    //}
    
    //func addBrowsingHistory2(title: String, imageUrl: String, articleUrl: String) {
    //    let newArticle = BrowsingHistoryData(title: title, link: imageUrl, contextLink: articleUrl)
    //    BrowsingHistoryDataSource(items: [newArticle])
    //}
    
}


extension GoogleApiViewController: UITableViewDelegate {

     func tableView(_ tabbleView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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

extension GoogleApiViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("リターンキータップ！！！")
        textField.resignFirstResponder()
        return true
    }
}
