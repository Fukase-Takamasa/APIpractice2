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
    
    let dataSource = RxTableViewSectionedReloadDataSource<GoogleDataSource>(configureCell: { dataSource, tableView, indexPath, item in
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        let title = item.items[indexPath.row].title
        let link = item.items[indexPath.row].link
        cell.googleBindData(title: title, link: link)
        return cell
    })
    
    var query: String?
    var startIndex = 1
    var pageIndex = 0
    //仮の検索実行フラグ
    var searchFlag = false
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        searchTextField?.delegate = self
        
        viewModel.outputs.articles
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

    }
    
    @IBAction func searchButton(_ sender: Any) {
        tableView.reloadData()
    }
    
    //テキストボックス内のクエリでMoyaAPI通信
    func FetchGoogleSearchAPI() {
        if searchFlag {
            searchFlag = false
        }else {
            searchFlag = true
        }
        
        //MoyaのAPI通信
        //let provider = MoyaProvider<GoogleApi>()

        //検索ワードをqueryに代入
        //query = searchTextField?.text
        
        //クエリがnilの時はAPIをリクエストしないで退出
        //guard let query = query else {
        //    return
        //}
        //    provider.request(.CustomSearch(query: query, startIndex: startIndex)) { (result) in
        //    switch result {
        //    case let .success(moyaResponse):
        //        print("（Google）moyaResponseの中身:\(moyaResponse)")
        //        do {
        //            //let data = try moyaResponse.map(GoogleData.self)
        //            let data = try JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
        //            self.googleData = data
        //            print("dataの中身:\(data)")
        //            print("GoogleAPIの取得データ:\(self.googleData)")
        //        }catch {
        //            print("GoogleAPIでエラーが出ました。")
        //        }
        //    case let .failure(error) :
        //        print("エラーの内容\(error.localizedDescription)")
        //        break
        //    }
            //通信後のMoyaのBlock内なのでメインスレッドでreloadさせる
            //DispatchQueue.main.async {
            //    self.tableViewGoogle.reloadData()
            //}
        //}
    }

}


extension GoogleApiViewController: UITableViewDelegate {
    
     //func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //    return googleData?.items.count ?? 0
     //}
     
     //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         //安全安ラップ
     //    guard let googleData = googleData else {
     //        return UITableViewCell()
     //    }
         
     //    let cell: GoogleApiCell = tableView.dequeueReusableCell(withIdentifier: GoogleApiCell.reusableIdentifier) as! GoogleApiCell
     //    let title = googleData.items[indexPath.row].title
     //    let link = googleData.items[indexPath.row].link
     //    cell.googleBindData(title: title, link: link)
     //    return cell
     //}
    
    
     
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
