//
//  RxDataSourcesDocumentsViewController.swift
//  RxSwiftDitto_Example
//
//  Created by Maximilian Alexander on 4/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DittoSwift
import RxSwift
import RxSwiftDitto
import RxDataSources
import Fakery


struct SectionOfCompanies: AnimatableSectionModelType {

    var items: [Company]

    init(items: [Company]) {
        self.items = items
    }

    init(original: SectionOfCompanies, items: [Company]) {
        self = original
        self.items = items
    }

    typealias Item = Company

    typealias Identity = String

    var identity: String {
        return "Just Companies"
    }

}

struct Company {

    var id: String
    var title: String
    var details: String
    var editedOn: Date

    init(document: DittoDocument) {
        id = document.id.toString()
        title = document["title"].stringValue
        details = document["details"].stringValue
        editedOn = {
            guard let value = document["editedOn"].string else {
                return Date()
            }
            let dateFormatter = ISO8601DateFormatter()
            return dateFormatter.date(from: value) ?? Date()
        }()
    }
}

/**
 Required protocols for RxDataSources
 */
extension Company: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return self.id
    }
}

class RxDataSourcesDocumentsViewController: UIViewController {

    var disposeBag = DisposeBag()

    let tableView = UITableView()
    var ditto = Ditto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Companies"

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let clearBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [addBarButtonItem, clearBarButtonItem]

        addBarButtonItem
            .rx
            .tap
            .bind { [unowned self] _ in
                try! self.ditto.store["companies"].insert([
                    "title": Faker().company.name(),
                    "details": Faker().company.bs(),
                    "editedOn": ISO8601DateFormatter().string(from: Date())
                ])
            }
            .disposed(by: disposeBag)

        clearBarButtonItem
            .rx
            .tap
            .bind { [unowned self] _ in
                self.ditto.store["companies"].findAll().remove()
            }
            .disposed(by: disposeBag)

        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfCompanies> { _, tableView, _, company in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = company.title
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, YYYY h:mm a"
                let formatedString = formatter.string(from: company.editedOn)
                return "Details: \(company.details)\nEditedOn: \(formatedString)"
            }()
            cell.detailTextLabel?.numberOfLines = 0
            return cell
        }

        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }

        ditto.setAccessLicense(Helper.licenseToken)
        ditto.startSync()

        let companies: Observable<[SectionOfCompanies]> = ditto.store["companies"]
            .findAll()
            .sort("editedOn", direction: .descending)
            .rx
            .liveQuery
            .map({ docs -> [SectionOfCompanies] in
                let companies: [Company] = docs.map({ doc in Company(document: doc) })
                return [SectionOfCompanies(items: companies)]
            })

        companies
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)

        tableView
            .rx
            .modelDeleted(Company.self)
            .bind { companyToDelete in
                let companyId = companyToDelete.id
                self.ditto.store["companies"].findByID(DittoDocumentID(value: companyId)).remove()
            }
            .disposed(by: disposeBag)
    }

    deinit {
        ditto.stopSync()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = self.view.frame
    }
}
