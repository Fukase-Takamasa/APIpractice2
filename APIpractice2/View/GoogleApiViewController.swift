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

class GoogleAPIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, StoryboardInstantiatable {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewGoogle: UITableView!
    var googleData: GoogleData?
    var query: String?
    var startIndex = 1
    var pageIndex = 0


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
        //検索ワードをqueryに代入
        query = searchTextField?.text
        //MoyaのAPI通信
        let provider = MoyaProvider<GoogleApi>()
        
        //クエリがnilの時はAPIをリクエストしないで退出
        guard let query = query else {
            return
        }
        provider.request(.CustomSearch(query: query, startIndex: startIndex)) { (result) in
            switch result {
            case let .success(moyaResponse):
                print("（Google）moyaResponseの中身:\(moyaResponse)")
                do {
                    //let data = try moyaResponse.map(GoogleData.self)
                    let data = try JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
                    self.googleData = data
                    print("dataの中身:\(data)")
                    print("GoogleAPIの取得データ:\(self.googleData)")
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
        
        let cell: GoogleApiCell = tableView.dequeueReusableCell(withIdentifier: GoogleApiCell.reusableIdentifier) as! GoogleApiCell
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
