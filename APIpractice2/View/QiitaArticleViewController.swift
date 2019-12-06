//
//  ArticleViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/04.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import WebKit
import Instantiate
import InstantiateStandard

class QiitaArticleViewController: UIViewController, StoryboardInstantiatable {
    
    var articleTitle: String?
    var articleUrl: String?
    
    @IBOutlet weak var articleWebView: WKWebView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //アドレスが無効な場合に表示するエラーメッセージ
        errorMessageLabel.isHidden = true
        
        //タイトルを上に表示
        self.navigationItem.title = articleTitle
        //タップされたセルの記事UrlをWebViewに表示

        //URL不正時のクラッシュ回避
        guard let url = URL(string: articleUrl ?? "") else {
            //エラーメッセージ表示
            errorMessageLabel.isHidden = false
            return
        }
        let request = URLRequest(url: url)
        articleWebView.load(request)
    }
    


}
