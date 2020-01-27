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

}

protocol ArticleViewModelOutputs {
    
}

protocol ArticleViewModelType {
    var inputs: ArticleViewModelInputs {get}
    var outputs: ArticleViewModelOutputs {get}
}

class ArticleViewModel: ArticleViewModelInputs, ArticleViewModelOutputs {
    //input
    
    
    //output
    
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //other
        self.scheduler = scheduler
        
        
        //output
        
        
        //input
        
        
        
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var inputs: ArticleViewModelInputs { return self}
    var outputs: ArticleViewModelOutputs { return self}
}
