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
    var cellModelData: AnyObserver<GoogleDataSource.Item> {get}
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
    var cellModelData: AnyObserver<GoogleDataSource.Item>
    
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
        let _cellModelData = PublishRelay<GoogleDataSource.Item>()
        self.cellModelData = AnyObserver<GoogleDataSource.Item>() { element in
            guard let data = element.element else {
                return
            }
            print("VM:cellModelDataの中身: \(data)")
            _cellModelData.accept(data)
        }
        
        _cellModelData.subscribe(onNext: { element in
            RealmFunction.addBrowsedArticleToRealm(title: element.title, imageUrl: element.link, articleUrl: element.image.contextLink)
            do {
                let realm = try Realm()
                _browsedArticles.accept(realm.objects(BrowsingHistory.self))
                print("realm.objectsの中身: \(realm.objects(BrowsingHistory.self))")
                print("RealmFunction: データを取得してacceptしました")
            }catch {
                print("RealmFunction: データを取得できませんでした")
            }
            
            
            //↓で取得したURLの使い方
            //RealmBrowser開いて、open file→　command + shift + Gでパス入力フォームを表示してから、 取得したURLのfile://より後ろだけを貼り付け。
            print("Realmの保存先URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
            }).disposed(by: disposeBag)
    }
}

extension BrowsingHistoryViewModel: BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs { return self}
    var outputs: BrowsingHistoryViewModelOutputs { return self}
}
