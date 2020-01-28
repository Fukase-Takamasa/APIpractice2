//
//  GoogleApi.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/06.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//


import Moya

//Moyaの設定
enum GoogleApi {
    case CustomSearch(query: String, startIndex: Int)
    //case CustomSearch

}

extension GoogleApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com")!
        //↓モックサーバーURL(stopLight起動してないと使えない）
        //return URL(string: "http://127.0.0.1:3100")!
    }
    
    var path: String {
        switch self {
        case .CustomSearch:
            return "/customsearch/v1"
            //return "/v1/test"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    //指定したクエリで画像検索するパラメータ（APIキーなどは自分のもの）
    var task: Task {
        switch self {
        case .CustomSearch(let query, let startIndex):
            return .requestParameters(parameters: ["key":"AIzaSyDVyxhFCjqj5shwAWzo0EI2nT81pHoMRDw", "cx":"009237515506121379779:giiokppklre", "searchType": "image", "q": query, "start": startIndex], encoding: URLEncoding.default)
        //case .CustomSearch:
            //return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
        //return nil
    }

    // テストの時などに、実際にAPIを叩かずにローカルのjsonファイルを読み込める
    var sampleData: Data {
        return Data()
    }
}
