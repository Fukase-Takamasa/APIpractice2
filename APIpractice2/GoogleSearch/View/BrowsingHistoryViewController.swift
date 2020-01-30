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
import Instantiate
import InstantiateStandard

class BrowsingHistoryViewController: UIViewController, UITableViewDelegate, StoryboardInstantiatable {

    var dataSource: BrowsingHistoryDataSource = BrowsingHistoryDataSource(items: [])

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        print("カウント:\(dataSource.items.count)")
        if !dataSource.items.isEmpty {
            print("配列の最後尾要素のタイトル:\(dataSource.items.last!.title)")
        }
    }
}

extension BrowsingHistoryViewController {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController.instantiate()
        vc.articleTitle = dataSource.items[indexPath.row].title
        vc.articleUrl = dataSource.items[indexPath.row].contextLink
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
