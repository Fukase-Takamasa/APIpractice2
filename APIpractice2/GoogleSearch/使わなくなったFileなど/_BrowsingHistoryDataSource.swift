//
//  BrowsingHistoryDataSource.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

//import UIKit
//import Foundation
//
//class BrowsingHistoryDataSource: NSObject {
//    typealias Element = [GoogleDataSource.Item]
//
//    var items: Element
//
//    init(items: Element) {
//        self.items = items
//    }
//
//}
//
//extension BrowsingHistoryDataSource: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = TableViewUtil.createCell(tableView, identifier: GoogleApiCell.reusableIdentifier, indexPath) as! GoogleApiCell
//        //let title = items[indexPath.row]
//        //let imageUrl = items[indexPath.row].link
//        //cell.googleBindData(title: title, imageUrl: imageUrl)
//        return cell
//    }
//
//}

