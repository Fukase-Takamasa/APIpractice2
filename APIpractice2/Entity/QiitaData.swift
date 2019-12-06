//
//  QiitaData.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Foundation

//APIで取得した値をCodableでパースする為の構造体
struct QiitaData: Codable {
    let title: String
    let url: String
}
