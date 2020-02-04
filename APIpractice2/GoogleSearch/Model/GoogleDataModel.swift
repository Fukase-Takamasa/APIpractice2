//
//  GoogleDataModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/02/04.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//APIで取得したデータを一覧VC以外でも扱いやすくしたくて作ったclass
//（使わなくなった）


//protocol GoogleDataModelInputs {
//    //input
//     var dataReceiver: AnyObserver<[GoogleDataSource]> {get}
//}
//
//class GoogleDataModel: GoogleDataModelInputs {
//    //input
//    var dataReceiver: AnyObserver<[GoogleDataSource]>
//
//    //other
//    private let scheduler: SchedulerType
//    private let disposeBag = DisposeBag()
//
//    var dataList: [GoogleDataSource] = []
//
//    static let sharedDataList: GoogleDataModel = GoogleDataModel()
//    private init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
//
//        //other
//        self.scheduler = scheduler
//
//        //input
//        let _dataReceriver = PublishRelay<[GoogleDataSource]>()
//        dataReceiver = AnyObserver<[GoogleDataSource]>() {element in
//            guard let data = element.element else {
//                return
//            }
//            _dataReceriver.accept(data)
//        }
//        _dataReceriver.subscribe(onNext: { element in
//            print("GoogleDataModel: elementの中身: \(element)")
//            }).disposed(by: disposeBag)
//
//
//    }
//
//}
