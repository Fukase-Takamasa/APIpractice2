//
//  BrowsingHistoryViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Instantiate
import InstantiateStandard

class BrowsingHistoryViewController: UIViewController, StoryboardInstantiatable {

    let disposeBag = DisposeBag()
    let historyViewModel: BrowsingHistoryViewModelType = BrowsingHistoryViewModel()
    
    //var dataSource: BrowsingHistoryDataSource = BrowsingHistoryDataSource(items: [])
    
    var browsingHistoryList: Results<BrowsingHistory>?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
        print("リロードしました")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        //output
        historyViewModel.outputs.browsedArticles
            .subscribe(onNext: { element in
                print("subscribeしたelementの中身: \(element)")
            }).disposed(by: disposeBag)
        print("viewDidLoadです")
    }
}

extension BrowsingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return browsingHistoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        guard let browsingHistoryList = browsingHistoryList else {
            return UITableViewCell()
        }
        let title = browsingHistoryList[indexPath.row].title
        let imageUrl = browsingHistoryList[indexPath.row].imageUrl
        cell.googleBindData(title: title, imageUrl: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController.instantiate()
        guard let browsingHistoryList = browsingHistoryList else {
            return
        }
        vc.articleTitle = browsingHistoryList[indexPath.row].title
        vc.articleUrl = browsingHistoryList[indexPath.row].articleUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
