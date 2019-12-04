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

//APIで取得した値をCodableでパース
struct QiitaData: Codable {
    let title: String
    let url: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var qiitaData:[QiitaData]?
    var selectCellTitle: String?
    var selectCellUrl: String?
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.register(UINib(nibName: "TableViewCell2", bundle:nil),  forCellReuseIdentifier: "TableViewCell2")
        //self.tableView.estimatedRowHeight = 100
        //self.tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        //MoyaでApi通信
        //取得してパースした値を最初に作ったqiita（structのインスタンス）に収納
        let provider = MoyaProvider<QiitaApi>()
        provider.request(.getArticle) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let data = try! JSONDecoder().decode([QiitaData].self, from: moyaResponse.data)
                    self.qiitaData = data
                    print(type(of: self.qiitaData))
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

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (qiitaData?.count ?? 0) / 2
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["Section0", "Section1"]
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //APIで取得した値を使用前に安全にアンラップ
        guard let qiitaData = qiitaData else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            //カスタムセル1種目を使用
            let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let title = qiitaData[indexPath.row].title
            //取り出したtitleの値をセルに表示する
            cell.bindData(text: title)
            return cell
            
        case 1:
            //カスタムセル2種目を使用
            let cell: TableViewCell2 = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2", for: indexPath) as! TableViewCell2
            //セクション1以降の記事を表示
            let title = qiitaData[(indexPath.row + (qiitaData.count / 2))].title
            //取り出したtitleの値をセルに表示する
            cell.bindData2(text: title)
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    //セルタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //非効率? ２回目アンラップ
        guard let qiitaData = qiitaData else {
            return
        }
        //セクション2の時は、indexにセクション1で表示した分を足す
        var index = indexPath.row
        if indexPath.section == 1 {
            index += (qiitaData.count / 2)
        }
        //遷移先に渡す値を変数にセット
        selectCellTitle = qiitaData[index].title
        selectCellUrl = qiitaData[index].url
        //遷移
        performSegue(withIdentifier: "toArticle", sender: nil)

    }
    
    //↑でタップされたセルに関する値を遷移先に渡す
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticle" {
            let vc = segue.destination as! ArticleViewController
            vc.articleTitle = selectCellTitle
            vc.articleUrl = selectCellUrl
        }
    }
    
    //セルの幅を自動調整
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


//↓Moyaを使うための準備

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
