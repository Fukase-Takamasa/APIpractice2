//
//  FavoriteArticleViewModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/27.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol FavoriteArticleViewModelInputs {
    var viewWillAppearTrigger: AnyObserver<[Any]> {get}
}

protocol FavoriteArticleViewModelOutputs {
    var favoriteArticles: Observable<[RealmDataSource]> {get}
}

protocol FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs {get}
    var outputs: FavoriteArticleViewModelOutputs {get}
}



class FavoriteArticleViewModel: FavoriteArticleViewModelInputs, FavoriteArticleViewModelOutputs {
    
    //input
    var viewWillAppearTrigger: AnyObserver<[Any]>
    
    //output
    var favoriteArticles: Observable<[RealmDataSource]>
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        let _favoriteArticles = PublishRelay<[RealmDataSource]>()
        self.favoriteArticles = _favoriteArticles.asObservable()
        
        //input
        let _viewWillAppearTrigger = PublishRelay<[Any]>()
        self.viewWillAppearTrigger = AnyObserver<[Any]>() { event in
            guard let event = event.element else {
                return
            }
            _viewWillAppearTrigger.accept(event)
        }
        
        _viewWillAppearTrigger.subscribe(onNext: { event in
            print("FavoVM: viewWillAppearTrigger")
            
            //Realmに保存されているデータを取得する処理
            do {
                let realm = try Realm()
                
                let data = realm.objects(FavoriteArticles.self)
                let dataArray = Array(data)
                
                let dataSource = RealmDataSource.init(items: dataArray)
                _favoriteArticles.accept([dataSource])
                print("FavoVM: realm.objectsの中身: \(realm.objects(FavoriteArticles.self))")
                print("RealmDataSourceのacceptする中身: \([dataSource])")
                print("FavoVM: RealmFunction: データを取得してacceptしました")
            }catch {
                print("FavoVM: RealmFunction: データを取得できませんでした")
            }
            //↓で取得したURLの使い方
            //RealmBrowser開いて、open file→　command + shift + Gでパス入力フォームを表示してから、 取得したURLのfile://より後ろだけを貼り付け。
            print("FavoVM: Realmの保存先URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
            
        }).disposed(by: disposeBag)
    }
}

extension FavoriteArticleViewModel: FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs { return self}
    var outputs: FavoriteArticleViewModelOutputs { return self}
}
