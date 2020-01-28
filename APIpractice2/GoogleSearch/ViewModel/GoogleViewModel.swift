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

protocol GoogleViewModelInputs {
    var searchQueryText: AnyObserver<String> {get}
    var searchButtonTapped: AnyObserver<Void> {get}
    var selectedCellIndex: AnyObserver<IndexPath> {get}
}

protocol GoogleViewModelOutputs {
    var articles: Observable<[GoogleDataSource]> {get}
    var error: Observable<Error> {get}
    var articleIndex: Observable<IndexPath> {get}
}

protocol GoogleViewModelType {
    var inputs: GoogleViewModelInputs {get}
    var outputs: GoogleViewModelOutputs {get}
}

class GoogleViewModel: GoogleViewModelInputs, GoogleViewModelOutputs {
    
    //input
    var searchQueryText: AnyObserver<String>
    var searchButtonTapped: AnyObserver<Void>
    var selectedCellIndex: AnyObserver<IndexPath>
    
    //output
    var articles: Observable<[GoogleDataSource]>
    var error: Observable<Error>
    var articleIndex: Observable<IndexPath>
    
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
        
        let _articleIndex = BehaviorRelay<IndexPath>(value: [0, 0])
        articleIndex = _articleIndex.asObservable()
        
        
        //input
        let _selectedCellIndex = PublishRelay<IndexPath>()
        self.selectedCellIndex = AnyObserver<IndexPath>() { element in
            guard let index = element.element else {
                print("selectedCellIndexがnilなのでreturnします")
                return
            }
            print("selectedCellIndex:　\(index)")
            _selectedCellIndex.accept(index)
        }
        
        _selectedCellIndex.subscribe(onNext: { element in
            print("articleIndex: \(element)")
            _articleIndex.accept(element)
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
