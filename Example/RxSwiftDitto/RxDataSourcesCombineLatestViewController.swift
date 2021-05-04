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

/**
 Required for RxDataSources
 */
extension Product: IdentifiableType {
    typealias Identity = String
    var identity: String {
        return self.id
    }
}

struct SectionOfProductsWithCompany: AnimatableSectionModelType {

    var company: Company!
    var items: [Product]

    init(company: Company, items: [Product]) {
        self.items = items
        self.company = company
    }

    /**
     Required for RxDataSources
     */
    init(original: SectionOfProductsWithCompany, items: [Product]) {
        self = original
        self.items = items
    }

    typealias Item = Product

    typealias Identity = String

    // the company name is what determines the section
    var identity: String {
        return company.id
    }

}

class RxDataSourcesCombineLatestViewController: UIViewController {

    var disposeBag = DisposeBag()

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Company + Products"

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        let clearBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [addBarButtonItem, clearBarButtonItem]

        addBarButtonItem
            .rx
            .tap
            .bind { _ in
                let faker = Faker()
                let companyDocs = AppDelegate.ditto.store["companies"].findAll().exec()
                let companyId: String
                if let randomCompany = companyDocs.map({ Company(document: $0) }).randomElement() {
                    companyId = randomCompany.id
                } else {
                    companyId = try! AppDelegate.ditto.store["companies"].insert([
                        "title": faker.company.name(),
                        "details": faker.company.bs(),
                        "editedOn": ISO8601DateFormatter().string(from: Date()),
                    ]).toString()
                }
                try! AppDelegate.ditto.store["products"].insert([
                    "title": faker.commerce.productName(),
                    "details": faker.lorem.paragraphs(amount:1),
                    "editedOn": ISO8601DateFormatter().string(from: Date()),
                    "companyId": companyId
                ])
            }
            .disposed(by: disposeBag)

        clearBarButtonItem
            .rx
            .tap
            .bind { _ in
                AppDelegate.ditto.store.write { trx in
                    trx["companies"].findAll().remove()
                    trx["products"].findAll().remove()
                }
            }
            .disposed(by: disposeBag)

        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfProductsWithCompany> { _, tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = "Product: \(item.title)"
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, YYYY h:mm a"
                let formatedString = formatter.string(from: item.editedOn)
                return "Details: \(item.details)\nEditedOn: \(formatedString)"
            }()
            cell.detailTextLabel?.numberOfLines = 0
            return cell
        }

        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }

        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            let companyName = dataSource.sectionModels[sectionIndex].company.title
            return "Company: \(companyName)"
        }

        let companies$: Observable<[Company]> = AppDelegate.ditto.store["companies"]
            .findAll()
            .sort("editedOn", direction: .descending)
            .rx
            .liveQuery
            .map({ docs in docs.map{ doc in Company(document: doc) } })

        let products$: Observable<[Product]> = AppDelegate.ditto.store["products"]
            .findAll()
            .sort("editedOn", direction: .descending)
            .rx
            .liveQuery
            .map({ docs in docs.map{ doc in Product(document: doc) } })

        // notice this combine latest
        // this is where the two live query results are "joined" together
        let companies: Observable<[SectionOfProductsWithCompany]> = Observable.combineLatest(companies$, products$) { companies, products in
            return companies.map({ company -> SectionOfProductsWithCompany in
                let productsForThisCompany = products.filter({ $0.companyId == company.id })
                return SectionOfProductsWithCompany(company: company, items: productsForThisCompany)
            })
        }

        companies
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = self.view.frame
    }
}
