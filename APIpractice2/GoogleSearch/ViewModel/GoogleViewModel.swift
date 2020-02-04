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
    var tappedCellButtonIndex: AnyObserver<Int> {get}
    var cellModelData: AnyObserver<GoogleDataSource.Item> {get}
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
    var tappedCellButtonIndex: AnyObserver<Int>
    var cellModelData: AnyObserver<GoogleDataSource.Item>
    
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
        let _tappedCellButtonIndex = PublishRelay<Int>()
        self.tappedCellButtonIndex = AnyObserver<Int>() { element in
            guard let index = element.element else {
                return
            }
            _tappedCellButtonIndex.accept(index)
        }
        
        _tappedCellButtonIndex.subscribe(onNext: {event in
            print("VM: tappedCellBUttonIndex: \(event)")
            }).disposed(by: disposeBag)
        
        let _cellModelData = PublishRelay<GoogleDataSource.Item>()
        self.cellModelData = AnyObserver<GoogleDataSource.Item>() { element in
            guard let data = element.element else {
                return
            }
            print("一覧VM:cellModelDataの中身: \(data)")
            _cellModelData.accept(data)
        }
        _cellModelData.subscribe(onNext: { element in
            //Realmに保存する処理
            print("一覧VM: cellModelDataが流れてきました")
            
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
            print("tapped")
            _searchButtonTapped.accept(tapped)
        }

        _searchButtonTapped
            .withLatestFrom(_searchQueryText.asObservable())
            .subscribe(onNext: { element in
                //(startIndexは1 → 1~10件の結果を取得, 11 → 11~20を取得できる。最大100件まで。
                //後にページングなど実装した時に使用する
                GoogleRepository.fetchGoogleData(query: element, startIndex: 1)
                .subscribe(onNext: { response in
                    print("VM: DataSourceのfetch()を呼び出し")
                    print("VMのonNext: responseの中身: \(response)")
                    let dataSource = GoogleDataSource.init(items: response.items)
                    print("VMのonNext: Viewに渡す[dataSource]の中身　: \([dataSource])")
                    _articles.accept([dataSource])
                }, onError: { error in
                    print("VMのonError: \(error)")
                    _error.accept(error)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
            
    }
    
}

extension GoogleViewModel: GoogleViewModelType {
    var inputs: GoogleViewModelInputs {return self}
    var outputs: GoogleViewModelOutputs {return self}
}
