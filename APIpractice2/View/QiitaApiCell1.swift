//
//  TableViewCell.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/03.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard

class QiitaApiCell1: UITableViewCell, Reusable {
    
    @IBOutlet weak var label: UILabel!

    func bindData(text: String) {
        label.text = text
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
