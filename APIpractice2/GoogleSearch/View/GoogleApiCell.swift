//
//  CellGoogle.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/04.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard
import AlamofireImage
import RxSwift
import RxCocoa

class GoogleApiCell: UITableViewCell, Reusable {
    
    var disposeBag = DisposeBag()
    let viewModel: FavoriteArticleViewModelType = FavoriteArticleViewModel()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    //取得したタイトルと画像を表示
    func googleBindData(title: String, imageUrl: String) {
        label.text = title
        googleImageView.af_setImage(withURL: URL(string: imageUrl)!)
    }
    
    //モックサーバー使用時用　画像なしver
    func googleBindTitle(title: String) {
        label.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.disposeBag = DisposeBag() //ここで毎回生成
        
        //input
//        favoriteButton.rx.tap.subscribe{ _ in
//            print("button.tag: \(self.favoriteButton.tag)")
//            //self.viewModel.inputs
//        }.disposed(by: disposeBag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
