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
    var items: [GoogleData]
}

extension GoogleDataSource: SectionModelType {
    typealias Item = GoogleData
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
    
}




