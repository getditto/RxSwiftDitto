//
//  ViewController.swift
//  RxSwiftDitto
//
//  Created by 2183729 on 04/28/2021.
//  Copyright (c) 2021 2183729. All rights reserved.
//

import UIKit

struct NavOption {
    var title: String
    var subtitle: String
    var viewController: UIViewController
}

class RootViewController: UITableViewController {


    var options: [NavOption] = [
        NavOption(
            title: "RxDataSources and RxSwiftDitto with DittoDocuments",
            subtitle: "This shows off how you can use RxSwiftDitto to bind to RxDataSources to show live document changes",
            viewController: RxDataSourcesDocumentsViewController()),
        NavOption(
            title: "RxDataSources and RxSwiftDitto with combineLatest",
            subtitle: "An example of simulating \"joins\" with multiple collections of companies and products",
            viewController: RxDataSourcesCombineLatestViewController())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxSwiftDitto"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let option = options[indexPath.row]
        cell.textLabel?.text = option.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        cell.detailTextLabel?.text = option.subtitle
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        let viewController = option.viewController
        navigationController?.pushViewController(viewController, animated: true)
    }

}

