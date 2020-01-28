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

class GoogleApiCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var googleImageView: UIImageView!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
