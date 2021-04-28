import XCTest
import RxSwift
import RxSwiftDitto
import DittoSwift
import Fakery

class Tests: XCTestCase {

    var ditto: Ditto!
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = Bundle.main.path(forResource: "license_token", ofType: "txt") // file path for file "data.txt"
        guard let text = try? String(contentsOfFile: path!) else {
            fatalError("please add a file called license_token.txt to the bundle and paste a valid Ditto license token")
        }
        let randomTemporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory(),
                                        isDirectory: true).appendingPathComponent(UUID().uuidString)
        ditto = Ditto(persistenceDirectory: randomTemporaryDirectory)
        ditto.setAccessLicense(text)
        ditto.startSync()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInsertions() {
        let expectation = XCTestExpectation(description: "Observes number of documents in live query")
        let collectionName: String = UUID().uuidString
        let collection: DittoCollection = ditto.store[collectionName]

        Observable.range(start: 0, count: 10)
            .map { _ -> [String: Any?] in
                return [
                    "name":["Honda", "Ford", "Toyota"].randomElement()!,
                    "color": ["red", "blue", "yellow"].randomElement()!
                ]
            }
            .subscribe(collection.rx.insert)
            .disposed(by: disposeBag)

        collection
            .findAll()
            .rx
            .liveQuery
            .subscribe(onNext: { docs in
                XCTAssertEqual(docs.count, 10)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 10.0)
        disposeBag = DisposeBag()
    }

    func testInsertionTransactions() {
        for _ in 0..<100 {
            ditto.store.write { trx in
                try! trx["cars"].insert([
                    "name": ["Honda", "Toyota", "Ford"].randomElement()!,
                    "color": ["red", "blue", "green"].randomElement()!,
                ])
            }
        }
        // This is an example of a functional test case.
        let numberOfDocs = ditto.store["cars"].findAll().exec()
        XCTAssertEqual(numberOfDocs.count, 100)
    }
    
    func testLiveQuery() {

    }
    
}
