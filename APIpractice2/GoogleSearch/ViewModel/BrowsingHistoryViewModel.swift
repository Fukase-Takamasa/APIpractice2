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
    var viewWillAppearTrigger: AnyObserver<[Any]> {get}
}

protocol BrowsingHistoryViewModelOutputs {
    var browsedArticles: Observable<[BrowsingHistoryDataSource]> {get}
}

protocol BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs {get}
    var outputs: BrowsingHistoryViewModelOutputs {get}
}

class BrowsingHistoryViewModel: BrowsingHistoryViewModelInputs, BrowsingHistoryViewModelOutputs {
    
    //input
    var viewWillAppearTrigger: AnyObserver<[Any]>

    //output
    var browsedArticles: Observable<[BrowsingHistoryDataSource]>

    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        let _browsedArticles = PublishRelay<[BrowsingHistoryDataSource]>()
        browsedArticles = _browsedArticles.asObservable()
        
        //input
        let _viewWillAppearTrigger = PublishRelay<[Any]>()
        self.viewWillAppearTrigger = AnyObserver<[Any]>() { event in
            guard let event = event.element else {
                return
            }
            _viewWillAppearTrigger.accept(event)
        }
        
        _viewWillAppearTrigger.subscribe(onNext: { event in
            print("履歴VM: viewWillAppearTrigger")
            
            //Realmに保存されているデータを取得する処理
            do {
                let realm = try Realm()
                let data = realm.objects(BrowsingHistory.self)
                //Realm版ArrayみたいなResults<Element>型だとacceptする上で都合が悪いのでArray型に変換
                let dataArray = Array(data)
                let dataSource = BrowsingHistoryDataSource.init(items: dataArray)
                _browsedArticles.accept([dataSource])
                print("履歴VM: realm.objectsの中身: \(realm.objects(FavoriteArticles.self))")
                print("履歴VM: RealmDataSourceのacceptする中身: \([dataSource])")
                print("履歴VM: RealmFunction: データを取得してacceptしました")
            }catch {
                print("履歴VM: RealmFunction: データを取得できませんでした")
            }
            //↓で取得したURLの使い方
            //RealmBrowser開いて、open file→　command + shift + Gでパス入力フォームを表示してから、 取得したURLのfile://より後ろだけを貼り付け。
            print("お気に入りVM: Realmの保存先URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        }).disposed(by: disposeBag)
    }
}

extension BrowsingHistoryViewModel: BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs { return self}
    var outputs: BrowsingHistoryViewModelOutputs { return self}
}
