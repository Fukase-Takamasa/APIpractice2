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

protocol FavoriteArticleViewModelInputs {
    var tappedButtonIndex: AnyObserver<Int> {get}
}

protocol FavoriteArticleViewModelOutputs {
}

protocol FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs {get}
    var outputs: FavoriteArticleViewModelOutputs {get}
}



class FavoriteArticleViewModel: FavoriteArticleViewModelInputs, FavoriteArticleViewModelOutputs {
    
    //input
    var tappedButtonIndex: AnyObserver<Int>
    
    //output
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        //output
        
        //input
        let _tappedButtonIndex = PublishRelay<Int>()
        self.tappedButtonIndex = AnyObserver<Int>() { element in
            guard let index = element.element else {
                return
            }
            _tappedButtonIndex.accept(index)
        }
        
        
        
        
    }
}

extension FavoriteArticleViewModel: FavoriteArticleViewModelType {
    var inputs: FavoriteArticleViewModelInputs { return self}
    var outputs: FavoriteArticleViewModelOutputs { return self}
}
