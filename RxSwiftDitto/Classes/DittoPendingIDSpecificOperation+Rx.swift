//
//  SingleDocument+Rx.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/28/21.
//

import RxSwift
import DittoSwift

public typealias DittoDocumentWithLiveQueryEvent = (DittoDocument?, DittoSingleDocumentLiveQueryEvent?)

extension DittoPendingIDSpecificOperation: ReactiveCompatible { }

extension Reactive where Base: DittoPendingIDSpecificOperation {

    public var liveQuery: Observable<DittoDocument?> {
        return Observable.create { observer in
            let l = self.base.observe { doc, _ in
                observer.onNext(doc)
            }
            return Disposables.create {
                l.stop()
            }
        }
    }

    public var liveQueryDocumentWithEvent: Observable<DittoDocumentWithLiveQueryEvent> {
        return Observable.create { observer in
            let l = self.base.observe { doc, event in
                observer.onNext((doc, event))
            }
            return Disposables.create {
                l.stop()
            }
        }
    }
}
