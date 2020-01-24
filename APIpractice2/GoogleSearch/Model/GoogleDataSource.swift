//
//  GoogleDataSource.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/10.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Foundation
import RxDataSources

struct GoogleDataSource {
    var items: [Item]
}

extension GoogleDataSource: SectionModelType {
    typealias Item = GoogleData.Items
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
    
}




