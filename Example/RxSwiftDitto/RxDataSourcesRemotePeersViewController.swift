//
//  RxDataSourcesRemotePeersViewController.swift
//  RxSwiftDitto_Example
//
//  Created by Maximilian Alexander on 5/12/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import DittoSwift
import RxSwift
import RxSwiftDitto
import RxDataSources
import UIKit

extension DittoRemotePeer: IdentifiableType, Equatable {

    public static func == (lhs: DittoRemotePeer, rhs: DittoRemotePeer) -> Bool {
        return lhs.connections == rhs.connections
            && lhs.deviceName == rhs.deviceName
            && lhs.rssi == rhs.rssi
            && lhs.networkId == rhs.networkId
    }

    public typealias Identity = String
    public var identity: String {
        return self.id
    }
}

struct SectionOfRemotePeers: AnimatableSectionModelType {
    var items: [DittoRemotePeer]

    init(original: SectionOfRemotePeers, items: [DittoRemotePeer]) {
        self = original
        self.items = items
    }

    init(items: [DittoRemotePeer]) {
        self.items = items
    }

    var identity: String {
        return "Peers"
    }

    typealias Item = DittoRemotePeer

    typealias Identity = String

}

class RxDataSourcesRemotePeersViewController: UIViewController {

    let tableView = UITableView()
    lazy var noConnectedPeersLabel: UILabel = {
        let label = UILabel()
        label.text = "No connected remote peers"
        label.textAlignment = .center
        if #available(iOS 13.0, *) {
            label.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            label.backgroundColor = UIColor.white
        }
        return label
    }()


    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noConnectedPeersLabel)
        title = "Remote Peers"

        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfRemotePeers> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = item.deviceName
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = item.connections.joined(separator: ",")
            return cell
        }

        AppDelegate.ditto
            .rx
            .peers
            .do(onNext: { [weak self] peers in
                self?.noConnectedPeersLabel.alpha = peers.count == 0 ? 1 : 0
            })
            .map({ [SectionOfRemotePeers(items: $0)] })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = self.view.frame
        noConnectedPeersLabel.frame = self.view.frame
    }

}
