//
//  BrowsingHistoryViewModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BrowsingHistoryViewModelInputs {
    var cellModelData: AnyObserver<GoogleDataSource.Item> {get}
}

protocol BrowsingHistoryViewModelOutputs {
    var browsedArticles: Observable<[BrowsingHistoryDataSource.Element]> {get}
}

protocol BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs {get}
    var outputs: BrowsingHistoryViewModelOutputs {get}
}

class BrowsingHistoryViewModel: BrowsingHistoryViewModelInputs, BrowsingHistoryViewModelOutputs {
    
    //input
    var cellModelData: AnyObserver<GoogleDataSource.Item>
    
    //output
    var browsedArticles: Observable<[BrowsingHistoryDataSource.Element]>

    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        let _browsedArticles = PublishRelay<[BrowsingHistoryDataSource.Element]>()
        browsedArticles = _browsedArticles.asObservable()
        
        //input
        let _cellModelData = PublishRelay<GoogleDataSource.Item>()
        self.cellModelData = AnyObserver<GoogleDataSource.Item>() { element in
            guard let data = element.element else {
                return
            }
            print("VM:cellModelDataの中身: \(data)")
            _cellModelData.accept(data)
        }
        
        _cellModelData.subscribe(onNext: { element in
            let dataSource = BrowsingHistoryDataSource.init(items: [element])
            print("dataSourceの中身: \([dataSource.items])")
            _browsedArticles.accept([dataSource.items])
            }).disposed(by: disposeBag)
    }
}

extension BrowsingHistoryViewModel: BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs { return self}
    var outputs: BrowsingHistoryViewModelOutputs { return self}
}
