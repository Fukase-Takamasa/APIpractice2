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
    var favoriteArticles: Observable<Results<FavoriteArticles>> {get}
}

protocol FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs {get}
    var outputs: FavoriteArticleViewModelOutputs {get}
}



class FavoriteArticleViewModel: FavoriteArticleViewModelInputs, FavoriteArticleViewModelOutputs {
    
    //input
    var viewWillAppearTrigger: AnyObserver<[Any]>
    
    //output
    var favoriteArticles: Observable<Results<FavoriteArticles>>
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        let _favoriteArticles = PublishRelay<Results<FavoriteArticles>>()
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
            }).disposed(by: disposeBag)
        
        //Realmに保存されているデータを取得する処理
        //do {
        //    let realm = try Realm()
        //_browsedArticles.accept(realm.objects(BrowsingHistory.self))
        //     print("realm.objectsの中身: \(realm.objects(BrowsingHistory.self))")
        //     print("RealmFunction: データを取得してacceptしました")
        // }catch {
        //     print("RealmFunction: データを取得できませんでした")
        // }
        
        
        //         //↓で取得したURLの使い方
        //         //RealmBrowser開いて、open file→　command + shift + Gでパス入力フォームを表示してから、 取得したURLのfile://より後ろだけを貼り付け。
        //         print("Realmの保存先URL: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
    }
}

extension FavoriteArticleViewModel: FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs { return self}
    var outputs: FavoriteArticleViewModelOutputs { return self}
}
