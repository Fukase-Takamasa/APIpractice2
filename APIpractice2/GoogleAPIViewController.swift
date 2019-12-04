//
//  GoogleAPIViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/04.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Instantiate
import InstantiateStandard

//GoogleAPIの取得データをパース
struct GoogleData: Codable {
    let title: String
    let url: String
}

class GoogleAPIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewGoogle: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGoogle.register(UINib(nibName: "CellGoogle", bundle: nil), forCellReuseIdentifier: "CellGoogle")
        tableViewGoogle.delegate = self
        tableViewGoogle.dataSource = self
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}

enum GoogleApi {
    case
}

extension GoogleApi: TargetType {
    var baseURL: URL {
        return URL(string: "")
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        .requestParameters(parameters: ["": ""], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
