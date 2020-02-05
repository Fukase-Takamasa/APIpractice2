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
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //取得したタイトルと画像を表示（画像読み込み中はno_image画像を表示）
    func googleBindData(title: String, imageUrl: String) {
        label.text = title
        guard let imageUrl = URL(string: imageUrl), let placeholder = UIImage(named: "no_image") else {
            return
        }
        googleImageView.af_setImage(withURL: imageUrl, placeholderImage: placeholder)
    }
    
    //モックサーバー使用時用　画像なしver
    func googleBindTitle(title: String) {
        label.text = title
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag() //セルの再利用前に毎回生成
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
