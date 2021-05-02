//
//  Ditto+Rx.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/30/21.
//

import DittoSwift
import RxSwift

extension Ditto: ReactiveCompatible { }

extension Reactive where Base: Ditto {

    /**
     An observable of `DittoRemotePeer`
     */
    var peers: Observable<[DittoRemotePeer]> {
        return Observable.create({ [weak base = self.base] observer in
            let h = base?.observePeers { peers in
                observer.onNext(peers)
            }
            return Disposables.create {
                h?.stop()
            }
        })
    }

}
