//
//  GoogleRepository.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/20.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Moya
import RxSwift

typealias GoogleAPIResponse = (( _ response: GoogleData?, _ error: Swift.Error?) -> Void)

final class GoogleRepository {
    private static let googleApiProvider = MoyaProvider<GoogleApi>()
    
    private static let disposeBag: DisposeBag = DisposeBag()
}

//vc.queryを、後でViewModelに移行したものを参照に変える
extension GoogleRepository {
    
    static func fetchGoogleData() -> Observable<GoogleData> {
        print("fetchGoogleData()実行")
        //return googleApiProvider.rx.request(.CustomSearch(query: "squirrel", startIndex: 0))
        return googleApiProvider.rx.request(.CustomSearch)
            .map { response in
            try JSONDecoder().decode(GoogleData.self, from: response.data)
        }.asObservable()
        //        let data = try JSONDecoder().decode(GoogleData.self, from: response.data)
        //    self.googleData = data
        //    print("dataの中身:\(data)")
        //    print("GoogleAPIの取得データ:\(self.googleData)")
            
       // }.asObservable()
            
            //.map([GoogleData].self)
        
    }
}
