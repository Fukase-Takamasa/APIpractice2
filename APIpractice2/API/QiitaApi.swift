//
//  QiitaApi.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Moya

//Moyaを使うためのセットアップ
//パラメーターなどは用途に応じてここで設定する(Taskのところ）

enum QiitaApi {
    case getArticle
}

extension QiitaApi: TargetType {

    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    var path: String {
        return "/api/v2/items"
    }
    
    var method: Moya.Method {
        switch self {
        case .getArticle:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: ["per_page" : "10"], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}

