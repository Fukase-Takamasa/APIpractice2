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
    
    var titles:[String] = []
    var links:[String] = []
    
    
    //let dataSource = RxTableViewSectionedReloadDataSource<GoogleDataSource>(configureCell: { dataSource, tableView, indexPath, item in
                
    //    let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
    //    print(item)
    //    let title = item.items[indexPath.row].title
    //    let link = item.items[indexPath.row].link
    //    print(indexPath)
    //    cell.googleBindData(title: title, link: link)
    //    return cell
    //})
    
    //var query: String?
    //var startIndex = 1
    //var pageIndex = 0
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField?.delegate = self
        
        viewModel.outputs.articles
            .subscribe(onNext: { element in
                
                for titleAndLink in element[0].items[0].items {
                    self.titles += [titleAndLink.title]
                    self.links += [titleAndLink.link]
                }
                self.tableView.reloadData()
                
                print("VC: elementの中身:\(element)")
                print(element.count)
                print(element[0].items.count)
                print(element[0].items[0].items[0].title)
                print(element[0].items[0].items.count)
                print(self.titles)
                print(self.links)
                
            }).disposed(by: disposeBag)
            //.bind(to: tableView.rx.items(dataSource: dataSource))
            //.disposed(by: disposeBag)
        
        //tableView.rx.setDelegate(self).disposed(by: disposeBag)

    }
    
    @IBAction func searchButton(_ sender: Any) {
        tableView.reloadData()
    }
    
    //テキストボックス内のクエリでMoyaAPI通信
    func FetchGoogleSearchAPI() {
        
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


extension GoogleApiViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
     }

     func tableView(_ tabbleView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         //if let height = self.cellHeightsDictionary[indexPath] {
          //   return height
         //}
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 130
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
        let title = self.titles[indexPath.row]
        let link = self.links[indexPath.row]
        cell.googleBindData(title: title, link: link)
        return cell
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
