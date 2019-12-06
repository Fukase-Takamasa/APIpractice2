//
//  TableViewUtil.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import UIKit

open class TableViewUtil {
    
    //”identifier”が違う事故をInstantiateを使って防ぐための書き方
    static func registerCell(_ tableView: UITableView, identifier: String) {
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    static func createCell(_ tableView: UITableView, identifier: String, _ indexPath: IndexPath) -> (UITableViewCell) {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
}
