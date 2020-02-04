//
//  GoogleApiViewModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2019/12/20.
//  Copyright © 2019 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol GoogleViewModelInputs {
    var searchQueryText: AnyObserver<String> {get}
    var searchButtonTapped: AnyObserver<Void> {get}
    var favoriteCellModelData: AnyObserver<GoogleDataSource.Item> {get}
    var historyCellModelData: AnyObserver<GoogleDataSource.Item> {get}

}

protocol GoogleViewModelOutputs {
    var articles: Observable<[GoogleDataSource]> {get}
    var error: Observable<Error> {get}
}

protocol GoogleViewModelType {
    var inputs: GoogleViewModelInputs {get}
    var outputs: GoogleViewModelOutputs {get}
}

class GoogleViewModel: GoogleViewModelInputs, GoogleViewModelOutputs {
    
    //input
    var searchQueryText: AnyObserver<String>
    var searchButtonTapped: AnyObserver<Void>
    var favoriteCellModelData: AnyObserver<GoogleDataSource.Item>
    var historyCellModelData: AnyObserver<GoogleDataSource.Item>
    
    //output
    var articles: Observable<[GoogleDataSource]>
    var error: Observable<Error>
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        
        //other
        self.scheduler = scheduler
        
        //output
        let _articles = PublishRelay<[GoogleDataSource]>()
        articles = _articles.asObservable()

        let _error = PublishRelay<Error>()
        error = _error.asObservable()
        
        
        //input
        let _favoriteCellModelData = PublishRelay<GoogleDataSource.Item>()
        self.favoriteCellModelData = AnyObserver<GoogleDataSource.Item>() { element in
            guard let data = element.element else {
                return
            }
            print("一覧VM:お気に入りdataの中身: \(data)")
            _favoriteCellModelData.accept(data)
        }
        _favoriteCellModelData.subscribe(onNext: { element in
            //お気に入り記事をRealmに保存する処理
            RealmModel.addFavoriteArticle(title: element.title, imageUrl: element.link, articleUrl: element.image.contextLink)
            print("一覧VM: お気に入りdataを保存しました")
            
            }).disposed(by: disposeBag)
        
        
        
        
        let _historyCellModelData = PublishRelay<GoogleDataSource.Item>()
        self.historyCellModelData = AnyObserver<GoogleDataSource.Item>() { element in
            guard let data = element.element else {
                return
            }
            print("一覧VM:履歴dataの中身: \(data)")
            _historyCellModelData.accept(data)
        }
        _historyCellModelData.subscribe(onNext: { element in
            //閲覧した記事をRealmに保存する処理
            RealmModel.addBrowsedArticle(title: element.title, imageUrl: element.link, articleUrl: element.image.contextLink)
            print("一覧VM: 履歴dataを保存しました")
            
            }).disposed(by: disposeBag)
        
        
        
        
        let _searchQueryText = BehaviorRelay<String>(value: "")
        self.searchQueryText = AnyObserver<String>() { element in
            guard let text = element.element else {
                return
            }
            _searchQueryText.accept(text)
        }
        
        let _searchButtonTapped = PublishRelay<Void>()
        self.searchButtonTapped = AnyObserver<Void>() { event in
            guard let tapped = event.element else {
                return
            }
            print("searchButtonTapped")
            _searchButtonTapped.accept(tapped)
        }

        _searchButtonTapped
            .withLatestFrom(_searchQueryText.asObservable())
            .subscribe(onNext: { element in
                //(startIndexは1 → 1~10件の結果を取得, 11 → 11~20を取得できる。最大100件まで。
                //後にページングなど実装した時に使用する
                GoogleRepository.fetchGoogleData(query: element, startIndex: 1)
                .subscribe(onNext: { response in
                    print("一覧VM: DataSourceのfetch()を呼び出し")
                    print("一覧VMのonNext: responseの中身: \(response)")
                    let dataSource = GoogleDataSource.init(items: response.items)
                    print("一覧VMのonNext: Viewに渡す[dataSource]の中身　: \([dataSource])")
                    _articles.accept([dataSource])
                }, onError: { error in
                    print("一覧VMのonError: \(error)")
                    _error.accept(error)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
            
    }
    
}

extension GoogleViewModel: GoogleViewModelType {
    var inputs: GoogleViewModelInputs {return self}
    var outputs: GoogleViewModelOutputs {return self}
}
