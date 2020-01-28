//
//  ArticleViewModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/27.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ArticleViewModelInputs {
    var selectedCellIndex: AnyObserver<IndexPath> {get}
}

protocol ArticleViewModelOutputs {
    var articleIndex: Observable<IndexPath> {get}
}

protocol ArticleViewModelType {
    var inputs: ArticleViewModelInputs {get}
    var outputs: ArticleViewModelOutputs {get}
}

class ArticleViewModel: ArticleViewModelInputs, ArticleViewModelOutputs {
    
    //input
    var selectedCellIndex: AnyObserver<IndexPath>
    
    //output
    var articleIndex: Observable<IndexPath>
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        
        //output
        let _articleIndex = PublishRelay<IndexPath>()
        self.articleIndex = _articleIndex.asObservable()
        
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
        
        
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var inputs: ArticleViewModelInputs { return self}
    var outputs: ArticleViewModelOutputs { return self}
}
