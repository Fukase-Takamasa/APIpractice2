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
        let _error = PublishRelay<Error>()
        
        GoogleRepository.fetchGoogleData()
            .subscribe(onNext: { response in
                print(response)
                print("VMのonNext: DataSourceのfetch()を呼び出し")
                let dataSource = GoogleDataSource.init(items: [response])
                print(dataSource)
                _articles.accept([dataSource])
            }, onError: { error in
                print("VMのonError: \(error)")
                _error.accept(error)
            }).disposed(by: disposeBag)
        
        articles = _articles.asObservable()
        error = _error.asObservable()
        
        //input
        let _searchQueryText = PublishRelay<String>()
        self.searchQueryText = AnyObserver<String>() { element in
            guard let text = element.element else {
                return
            }
            _searchQueryText.accept(text)
        }
    }
    
}

extension GoogleViewModel: GoogleViewModelType {
    var inputs: GoogleViewModelInputs {return self}
    var outputs: GoogleViewModelOutputs {return self}
}
