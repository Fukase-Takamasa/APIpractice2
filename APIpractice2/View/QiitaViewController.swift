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

class QiitaViewController: UIViewController, StoryboardInstantiatable {
    
    var qiitaData:[QiitaData]?
    var selectCellTitle: String?
    var selectCellUrl: String?
    //遷移先のビューがどれかを取得
    fileprivate let vc:QiitaArticleViewController = QiitaArticleViewController.instantiate()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiateを使った書き方
        TableViewUtil.registerCell(tableView, identifier: QiitaApiCell1.reusableIdentifier)
        TableViewUtil.registerCell(tableView, identifier: QiitaApiCell2.reusableIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchQiitaArticle()
        
        //↓通常の書き方
        //self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        //self.tableView.register(UINib(nibName: "TableViewCell2", bundle:nil),  forCellReuseIdentifier: "TableViewCell2")
        
        
        //self.tableView.estimatedRowHeight = 100
        //self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MoyaAPI通信で渡されるURLが無効だったときのテスト（何もURLを渡さないで遷移する）
    @IBAction func testEnableURLButton(_ sender: Any) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    
    //MoyaでApiリクエストし、最新記事を取得
    //取得してパースした値を最初に作ったqiita（structのインスタンス）に収納
    private func fetchQiitaArticle() {
        let provider = MoyaProvider<QiitaApi>()
        provider.request(.getArticle) { (result) in
            switch result {
            case let .success(moyaResponse):
                print("（Qiita）moyaResponseの中身:\(moyaResponse)")
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
            //通信後のMoyaのBlock内なのでメインスレッドでreloadさせる
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}




extension QiitaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (qiitaData?.count ?? 0) / 2
    }
    
    //各セクションのヘッダー
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["Section0", "Section1"]
        return sectionTitles[section]
    }
    
    //セルの幅
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //APIで取得した値を使用前に安全にアンラップ
        guard let qiitaData = qiitaData else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            //カスタムセル1種目を使用
            let cell: QiitaApiCell1 = tableView.dequeueReusableCell(withIdentifier: QiitaApiCell1.reusableIdentifier, for: indexPath) as! QiitaApiCell1
            let title = qiitaData[indexPath.row].title
            //取り出したtitleの値をセルに表示する
            cell.bindData(text: title)
            return cell
            
        case 1:
            //カスタムセル2種目を使用
            let cell: QiitaApiCell2 = tableView.dequeueReusableCell(withIdentifier: QiitaApiCell2.reusableIdentifier, for: indexPath) as! QiitaApiCell2
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
        print(indexPath.section, indexPath.row)
        
        print(index)
        
        //遷移先の変数に値を渡してから遷移。
        vc.articleTitle = qiitaData[index].title
        vc.articleUrl = qiitaData[index].url
        //（segueを使わないNavigationController経由での遷移の書き方。Instantiateも使って"Identifier"ミスを防いでいる）
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


