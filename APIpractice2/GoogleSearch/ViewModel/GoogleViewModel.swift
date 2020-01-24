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
                GoogleRepository.fetchGoogleData(query: element, startIndex: 0)
                .subscribe(onNext: { response in
                    print("VM: DataSourceのfetch()を呼び出し")
                    print("VMのonNext: responseの中身: \(response)")
                    let dataSource = GoogleDataSource.init(items: [response])
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
