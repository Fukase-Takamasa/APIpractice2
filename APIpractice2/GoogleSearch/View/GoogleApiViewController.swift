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
    
    var googleData: GoogleData?
    var query: String?
    var startIndex = 1
    var pageIndex = 0
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewGoogle: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiateを使ったセルの登録
        TableViewUtil.registerCell(tableViewGoogle, identifier: GoogleApiCell.reusableIdentifier)
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
        
        //クエリがnilの時はAPIをリクエストしないで退出
        guard let query = query else {
            return
        }
        
        let provider = MoyaProvider<GoogleApi>()
        
        provider.rx.request(.CustomSearch(query: query, startIndex: startIndex))
            .filterSuccessfulStatusCodes()
            .map(googleData.self)
            .subscribe(onSuccess: { (googleData) in
                
            }) { (error) in
                print(error)
        }.disposed(by: disposeBag)
            //let .success(moyaResponse):
            //    print("（Google）moyaResponseの中身:\(moyaResponse)")
            //    do {
            //        //let data = try moyaResponse.map(GoogleData.self)
            //        let data = try JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
            //        self.googleData = data
            //        print("dataの中身:\(data)")
            //        print("GoogleAPIの取得データ:\(self.googleData)")
            //    }catch {
            //        print("GoogleAPIでエラーが出ました。")
            //    }

            
            //通信後のMoyaのBlock内なのでメインスレッドでreloadさせる
            //DispatchQueue.main.async {
            //    self.tableViewGoogle.reloadData()
            //}
        //}
    }

}


extension GoogleApiViewController: UITableViewDelegate, UITableViewDataSource {
    
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
     
     //private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
     
     //func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     //    self.cellHeightsDictionary[indexPath] = cell.frame.size.height
     //}
     
     func tableView(_ tabbleView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         //if let height = self.cellHeightsDictionary[indexPath] {
          //   return height
         //}
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 130
     }
}

extension GoogleApiViewController: UITextFieldDelegate {
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
