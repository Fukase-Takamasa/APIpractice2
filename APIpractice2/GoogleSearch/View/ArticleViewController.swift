//
//  ArticleViewController.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/24.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import Instantiate
import InstantiateStandard

class ArticleViewController: UIViewController, StoryboardInstantiatable {

    let disposeBag = DisposeBag()
    //let viewModel: ArticleViewModelType = ArticleViewModel()
    //let viewModel: GoogleViewModelType = GoogleViewModel()
    
    var articleTitle: String?
    var articleUrl: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //output
        //viewModel.outputs.articles
        //    .subscribe(onNext: { element in
        //        print("記事画面:element articles: \(element)")
        //    }).disposed(by: disposeBag)
        
        //viewModel.outputs.articleIndex
        //.subscribe(onNext: { element in
        //    print("記事画面:element articleIndex: \(element)")
        //}).disposed(by: self.disposeBag)
        
        
        self.navigationItem.title = articleTitle
        //let request = URLRequest(url: URL(string: articleUrl ?? "")!)
        //webView.load(request)
    }
    
}
