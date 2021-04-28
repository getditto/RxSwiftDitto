//
//  DittoPendingCursorIDOperation+Rx.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/28/21.
//

import RxSwift
import DittoSwift

public typealias DittoDocumentWithLiveQueryEvent = (DittoDocument?, DittoSingleDocumentLiveQueryEvent?)

extension DittoPendingIDSpecificOperation: ReactiveCompatible {}

extension Reactive where Base: DittoPendingIDSpecificOperation {

    /**
     A live query to a `DittoDocument`. This is `nil` if the document does not exist
     */
    public var liveQuery: Observable<DittoDocument?> {
        return Observable.create { observer in

            let handler = self.base.observe { doc, _ in
                observer.onNext(doc)
            }

            return Disposables.create {
                handler.stop()
            }
        }
    }

    /**
     A live query with event info. This is useful to introspect additional information
     about the live query. 
     */
    public var liveQueryWithEvent: Observable<DittoDocumentWithLiveQueryEvent> {
        return Observable.create { observer in

            let handler = self.base.observe { doc, eventInfo in
                observer.onNext((doc, eventInfo))
            }

            return Disposables.create {
                handler.stop()
            }
        }
    }

}
