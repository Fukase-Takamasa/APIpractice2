//
//  ViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/03.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Instantiate
import InstantiateStandard

struct QiitaData: Codable {
    let title: String
    let url: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var qiita:[QiitaData]?
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        let provider = MoyaProvider<QiitaApi>()
        provider.request(.getArticle) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let qiitaData = try! JSONDecoder().decode([QiitaData].self, from: moyaResponse.data)
                    self.qiita = qiitaData
                    print(type(of: qiitaData))
                }catch {
                    print("error")
                }
            case let .failure(error):
                print(error.localizedDescription)
                break
            }
            self.tableView.reloadData()
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qiita?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        guard let qiita = qiita else {
            return UITableViewCell()
        }
        
        let title = qiita[indexPath.row].title
        let url = qiita[indexPath.row].url
        cell.bindData(text: "title: \(title)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


enum QiitaApi {
    case getArticle
}

extension QiitaApi: TargetType {
    
    
    
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    var path: String {
        return "/api/v2/items"
    }
    
    var method: Moya.Method {
        switch self {
        case .getArticle:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        .requestParameters(parameters: ["per_page" : "10"], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
    
}
