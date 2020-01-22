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
    
    private static let vc = GoogleApiViewController.instantiate()

}

//vc.queryを、後でViewModelに移行したものを参照に変える
extension GoogleRepository {
    
    static func fetchGoogleData() -> Observable<[GoogleData]> {
        return googleApiProvider.rx.request(.CustomSearch(query: vc.query ?? "apple", startIndex: vc.startIndex))
            .map([GoogleData].self)
            .asObservable()
    }
}
