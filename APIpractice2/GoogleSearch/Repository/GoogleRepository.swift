//
//  GoogleRepository.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/20.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

typealias GoogleAPIResponse = (( _ response: GoogleData?, _ error: Swift.Error?) -> Void)

final class GoogleRepository {
    
    private static let googleApiProvider = MoyaProvider<GoogleApi>()
    
    private static let disposeBag: DisposeBag = DisposeBag()
}

extension GoogleRepository {
    
    static func fetchGoogleData(query: String, startIndex: Int) -> Observable<GoogleData> {
        print("fetchGoogleData()実行")
        print("query:\(query), startIndex:\(startIndex)")
        return googleApiProvider.rx.request(.CustomSearch)
        //return googleApiProvider.rx.request(.CustomSearch(query: query, startIndex: startIndex))
            .map { response in
            try JSONDecoder().decode(GoogleData.self, from: response.data)
        }.asObservable()
        

        //.map([GoogleData].self)
    // }.asObservable()
    }
}
