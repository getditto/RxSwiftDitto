//
//  Writes.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/28/21.
//

import RxSwift
import DittoSwift

// Add this so the `.rx` namespace is available
extension DittoCollection: ReactiveCompatible { }

public extension Reactive where Base: DittoCollection {

    var insert: AnyObserver<[String: Any?]> {
        return AnyObserver { observer in
            guard let element = observer.element else { return }
            _ = try? base.insert(element)
        }
    }

    
}
