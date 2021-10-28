
import DittoSwift
import RxSwift

public typealias DittoDocumentsWithLiveQueryEvent = ([DittoDocument], DittoLiveQueryEvent?)

extension DittoPendingCursorOperation: ReactiveCompatible { }

extension Reactive where Base: DittoPendingCursorOperation {

    /**
     * Attempt to transform the live query documents into a Codable type.
     * This observable can fail in the event decoding fails.
     */
    public func liveQuery<T: Codable>(typed: T.Type) -> Observable<[T]> {
        return Observable.create { observer in
            let liveQuery = self.base.observe(eventHandler: { docs, _ in
                do {
                    let items = try docs.map({ try $0.typed(as: typed).value })
                    observer.onNext(items)
                } catch (let err) {
                    observer.onError(err)
                }
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
    public var liveQuery: Observable<DittoDocumentsWithLiveQueryEvent> {
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
