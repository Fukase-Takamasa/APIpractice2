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
import RealmSwift

protocol BrowsingHistoryViewModelInputs {
}

protocol BrowsingHistoryViewModelOutputs {
    var browsedArticles: Observable<Results<BrowsingHistory>> {get}
}

protocol BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs {get}
    var outputs: BrowsingHistoryViewModelOutputs {get}
}

class BrowsingHistoryViewModel: BrowsingHistoryViewModelInputs, BrowsingHistoryViewModelOutputs {
    
    //input
    
    //output
    var browsedArticles: Observable<Results<BrowsingHistory>>

    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        let _browsedArticles = PublishRelay<Results<BrowsingHistory>>()
        browsedArticles = _browsedArticles.asObservable()
        
        //input
        
            
            //Realmに保存されているデータを取得する処理
            //do {
            //    let realm = try Realm()
            //_browsedArticles.accept(realm.objects(BrowsingHistory.self))
            //     print("realm.objectsの中身: \(realm.objects(BrowsingHistory.self))")
            //     print("RealmFunction: データを取得してacceptしました")
            // }catch {
            //     print("RealmFunction: データを取得できませんでした")
            // }
    }
}

extension BrowsingHistoryViewModel: BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs { return self}
    var outputs: BrowsingHistoryViewModelOutputs { return self}
}
