//
//  CellGoogle.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/04.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import AlamofireImage

class CellGoogle: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var googleImageView: UIImageView!
    
    //取得したタイトルを表示
    func googleBindData(title: String, url: String) {
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
