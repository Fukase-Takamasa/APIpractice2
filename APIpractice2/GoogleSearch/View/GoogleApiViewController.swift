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
    
    let dataSource = RxTableViewSectionedReloadDataSource<GoogleDataSource>(configureCell: {
    dataSource, tableView, indexPath, item in
    let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath)
    as! GoogleApiCell
    print(item)
    let title = item.title
    let imageUrl = item.link
    print(indexPath)
    cell.googleBindData(title: title, imageUrl: imageUrl)
    //cell.googleBindTitle(title: title)
    print("セルを生成")
    return cell
    })
    
    //var startIndex = 1
    //var pageIndex = 0
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableViewUtil.registerCell(tableView, identifier: GoogleApiCell.reusableIdentifier)
        
        searchTextField?.delegate = self
        
        //input
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.searchQueryText)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.inputs.searchButtonTapped)
            .disposed(by: disposeBag)
        
        //output
        viewModel.outputs.articles
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //other
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected((GoogleDataSource.Item.self))
            .subscribe(onNext: { [weak self] model in
                let vc = ArticleViewController.instantiate()
                print("modelの中身: \(model)")
                vc.articleTitle = model.title
                vc.articleUrl = model.image.contextLink
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)

    }
}


extension GoogleApiViewController: UITableViewDelegate {

     func tableView(_ tabbleView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
        textField.resignFirstResponder()
        return true
    }
}
