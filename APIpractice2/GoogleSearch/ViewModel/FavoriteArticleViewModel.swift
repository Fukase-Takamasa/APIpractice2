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
    var tappedButtonIndex: AnyObserver<Int> {get}
    var cellModelData: AnyObserver<[String: String]> {get}
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
    var tappedButtonIndex: AnyObserver<Int>
    var cellModelData: AnyObserver<[String: String]>
    
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
        let _tappedButtonIndex = PublishRelay<Int>()
        self.tappedButtonIndex = AnyObserver<Int>() { element in
            guard let index = element.element else {
                return
            }
            print("FavoVM: tappedButtonIndex: \(index)")
            _tappedButtonIndex.accept(index)
        }
        
        let _cellModelData = PublishRelay<[String: String]>()
        self.cellModelData = AnyObserver<[String: String]>() { element in
            guard let data = element.element else {
                return
            }
            print("FavoVM: cellModelData: \(data)")
            _cellModelData.accept(data)
        }
        _cellModelData.subscribe(onNext: { element in
            
            //Realmに保存処理
            RealmModel.addFavoriteArticle(title: element["title"] ?? "値なし", imageUrl: element["imageUrl"] ?? "", articleUrl: element["articleUrl"] ?? "")
            }).disposed(by: disposeBag)
        
        
    }
}

extension FavoriteArticleViewModel: FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs { return self}
    var outputs: FavoriteArticleViewModelOutputs { return self}
}
