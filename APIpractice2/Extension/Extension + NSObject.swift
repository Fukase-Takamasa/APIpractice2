//
//  Extension + NSObject.swift
//  APIpractice2
//
//  Created by 深瀬 貴将 on 2020/02/04.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

extension UIViewController {

    private func trigger(selector: Selector) -> Observable<Void> {
        return rx_sentMessage(selector).map { _ in () }.shareReplay(1)
    }

    var viewWillAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillAppear(_:)))
    }

    var viewDidAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidAppear(_:)))
    }

    var viewWillDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillDisappear(_:)))
    }

    var viewDidDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidDisappear(_:)))
    }

}
