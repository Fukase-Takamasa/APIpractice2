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
import Foundation

//Google画像検索APIの取得データをパース
struct GoogleData: Codable {
    var items:[Items]
    
    struct Items: Codable {
        //タイトル
        var title: String
        //画像のURL
        var link: String
    }
}

class GoogleAPIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewGoogle: UITableView!
    var googleData: GoogleData?
    var query: String?
    var startPageNum = 1


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGoogle.register(UINib(nibName: "CellGoogle", bundle: nil), forCellReuseIdentifier: "CellGoogle")
        tableViewGoogle.delegate = self
        tableViewGoogle.dataSource = self
        searchTextField?.delegate = self
    }
    

    @IBAction func searchButton(_ sender: Any) {
        FetchGoogleSearchAPI()
    }
    
    
    
    //テキストボックス内のクエリでMoyaAPI通信
    func FetchGoogleSearchAPI() {
        query = searchTextField?.text
        //MoyaのAPI通信
        let provider = MoyaProvider<GoogleApi>()
        
        guard let query = query else {
            return
        }
        provider.request(.CustomSearch(query: query, startPage: startPageNum)) { (result) in
            switch result {
            case let .success(moyaResponse):
                print("（Google）moyaResponseの中身:\(moyaResponse)")
                do {
                    //let data = try moyaResponse.map(GoogleData.self)
                    let data = try JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
                    self.googleData = data
                    print("GoogleAPIの取得データ\(self.googleData)")
                }catch {
                    print("GoogleAPIでエラーが出ました。")
                }
            case let .failure(error) :
                print("エラーの内容\(error.localizedDescription)")
                break
            }
            
            //通信後のMoyaのBlock内なのでメインスレッドでreloadさせる
            DispatchQueue.main.async {
                self.tableViewGoogle.reloadData()
            }
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googleData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //安全安ラップ
        guard let googleData = googleData else {
            return UITableViewCell()
        }
        
        let cell: CellGoogle = tableView.dequeueReusableCell(withIdentifier: "CellGoogle") as! CellGoogle
        let title = googleData.items[indexPath.row].title
        let link = googleData.items[indexPath.row].link
        cell.googleBindData(title: title, link: link)
        return cell
    }
    
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    //func tableView(_ tabbleView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      //  if let height = self.cellHeightsDictionary[indexPath] {
        //    return height
        //}
        //return UITableView.automaticDimension
    //}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    //func tableView(_ tableView: UITableView, estimatedHeightForRowAt: IndexPath) -> CGFloat {
   //     return 100
    //}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("リターンキータップ！！！")
        FetchGoogleSearchAPI()
        textField.resignFirstResponder()
        return true
    }
    
}


//Moyaの設定
enum GoogleApi {
    case CustomSearch(query: String, startPage: Int)
  //case CustomSearch(String)
}

extension GoogleApi: TargetType {
    
    //struct searchQuery {
        //var searchQuery: String?
    //}
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com")!
    }
    
    var path: String {
        switch self {
        case .CustomSearch:
            return "/customsearch/v1"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    //指定したクエリで画像検索するパラメータ（APIキーなどは自分のもの）

    var task: Task {
        switch self {
      //case .CustomSearch(let query)
        case .CustomSearch(let query, let startPage):
            return .requestParameters(parameters: ["key":"AIzaSyDVyxhFCjqj5shwAWzo0EI2nT81pHoMRDw", "cx":"009237515506121379779:giiokppklre", "searchType": "image", "q": query, "start": startPage], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
