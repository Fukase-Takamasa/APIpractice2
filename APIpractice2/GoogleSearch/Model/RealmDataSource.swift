//
//  RealmDataSource.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/02/04.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

struct RealmDataSource {
    var items: [Item]
}

extension RealmDataSource: SectionModelType {
    typealias Item = Results<FavoriteArticles>
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}
