
import DittoSwift
import RxSwift

public typealias DittoDocumentsWithLiveQueryEvent = ([DittoDocument], DittoLiveQueryEvent?)

extension DittoPendingCursorOperation: ReactiveCompatible { }

extension Reactive where Base: DittoPendingCursorOperation {

    /**
     Returns an observable of `[DittoDocument]` which will fire for each snapshot change of the query
     */
    public var liveQuery: Observable<[DittoDocument]> {
        return Observable.create { observer in
            let liveQuery = self.base.observe(eventHandler: { docs, _ in
                observer.onNext(docs)
            })
            return Disposables.create {
                liveQuery.stop()
            }
        }
    }


    /**
     Returns an observable of ([DittoDocument], DittoLiveQueryEvent?)
     This is useful for discerning what has happened since the last sync value.
     */
    public var liveQueryDocumentsWithEvent: Observable<DittoDocumentsWithLiveQueryEvent> {
        return Observable.create { observer in
            let liveQuery = base.observe(eventHandler: { docs, event in
                observer.onNext((docs, event))
            })
            return Disposables.create {
                liveQuery.stop()
            }
        }
    }

}
