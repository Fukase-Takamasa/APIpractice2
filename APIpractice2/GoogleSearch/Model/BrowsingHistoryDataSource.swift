//
//  BrowsingHistoryDataSource.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/02/05.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

struct BrowsingHistoryDataSource {
    var items: [Item]
}

extension BrowsingHistoryDataSource: SectionModelType {
    typealias Item = BrowsingHistory
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}
