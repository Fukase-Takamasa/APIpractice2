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

class BrowsingHistoryViewController: UIViewController, StoryboardInstantiatable {
    let dataSource = BrowsingHistoryData().browsingHistory

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
