//
//  BrowsingHistoryViewModel.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/01/30.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BrowsingHistoryViewModelInputs {
    
}

protocol BrowsingHistoryViewModelOutputs {
}

protocol BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs {get}
    var outputs: BrowsingHistoryViewModelOutputs {get}
}

class BrowsingHistoryViewModel: BrowsingHistoryViewModelInputs, BrowsingHistoryViewModelOutputs {
    
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

extension BrowsingHistoryViewModel: BrowsingHistoryViewModelType {
    var inputs: BrowsingHistoryViewModelInputs { return self}
    var outputs: BrowsingHistoryViewModelOutputs { return self}
}
