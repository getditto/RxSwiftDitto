//
//  DittoExtensions.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/28/21.
//

import RxSwift
import DittoSwift

extension Ditto: ReactiveCompatible {}

extension Reactive where Base: Ditto {

    /**
     Observes the remote peers
     */
    var remotePeers: Observable<[DittoRemotePeer]> {
        return Observable.create { [weak base = self.base] observer in

            let o: DittoPeersObserver? = base?.observePeers { remotePeers in
                observer.onNext(remotePeers)
            }

            return Disposables.create {
                o?.stop()
            }
        }
    }

}
