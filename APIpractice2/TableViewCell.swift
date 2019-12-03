//
//  TableViewCell.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/03.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    func bindData(text: String) {
        label.text = text
    }
    
    
}
