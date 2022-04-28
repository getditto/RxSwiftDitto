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
    /**
     * Returns an observable typed as a Codable. If the document isn't available, it emit `nil`.
     * If the decoding fails for some reason, the observable will stop and emit an error
     */
    public func liveQuery<T: Codable>(typed: T.Type) -> Observable<T?> {
        return Observable.create { observer in
            let l = self.base.observe { doc, _ in
                guard let doc = doc else { return }
                do {
                    let decoded = try doc.typed(as: typed).value
                    observer.onNext(decoded)
                } catch(let err) {
                    observer.onError(err)
                }
            }
            return Disposables.create {
                l.stop()
            }
        }
    }

    /**
     * Returns an observable of the live query
     */
    public var liveQuery: Observable<DittoDocumentWithLiveQueryEvent> {
        return Observable.create { observer in
            let l = self.base.observe { doc, event in
                observer.onNext((doc, event))
            }
            return Disposables.create {
                l.stop()
            }
        }
    }

    /**
     * Returns an observable of the live query
     */
    public func liveQuery(deliverOn queue: DispatchQueue = .main) -> Observable<DittoDocumentWithLiveQueryEvent> {
        return Observable.create { observer in
            let l = self.base.observe(deliverOn: queue) { doc, event in
                observer.onNext((doc, event))
            }
            return Disposables.create {
                l.stop()
            }
        }
    }
}
