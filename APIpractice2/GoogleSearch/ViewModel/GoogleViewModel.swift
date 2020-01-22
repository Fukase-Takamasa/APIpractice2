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
    
}

protocol GoogleViewModelOutputs {
    
}

protocol GoogleViewModelType {
    var inputs: GoogleViewModelInputs {get}
    var outputs: GoogleViewModelOutputs {get}
}

class GoogleViewModel: GoogleViewModelInputs, GoogleViewModelOutputs {
    
    //let articles: Observable<GoogleData>
    //let error: Observable<Error>
    
    //input
    
    
    //output
    
    
    //other
    private let scheduler: SchedulerType
    private let disposeBag = DisposeBag()
    
    init(scheduler: SchedulerType = ConcurrentMainScheduler.instance) {
        //let _articles = PublishRelay<GoogleData>()
        //let _error = PublishRelay<Error>()
        
        //other
        self.scheduler = scheduler
        
        //output
        
        
        
        //input
        
        
        
    }
    
    
}

extension GoogleViewModel: GoogleViewModelType {
    var inputs: GoogleViewModelInputs {return self}
    var outputs: GoogleViewModelOutputs {return self}
}
