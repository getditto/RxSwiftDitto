import XCTest
import RxSwift
import RxSwiftDitto
import DittoSwift
import Fakery

fileprivate struct Car: Codable {
    var _id: String
    var name: String
    var mileage: Double
    var tags: [Int]
}

class Tests: XCTestCase {

    var ditto: Ditto!
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let randomTemporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory(),
                                        isDirectory: true).appendingPathComponent(UUID().uuidString)
        ditto = Ditto(persistenceDirectory: randomTemporaryDirectory)
        ditto.setAccessLicense(Helper.licenseToken)
        ditto.startSync()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLiveQueryForPendingCursor() {
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
            .subscribe(onNext: { paylod in
                try! collection.insert(paylod)
            })
            .disposed(by: disposeBag)

        collection
            .findAll()
            .rx
            .liveQuery
            .subscribe(onNext: { (docs, _) in
                XCTAssertEqual(docs.count, 10)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 10.0)
        disposeBag = DisposeBag()
    }

    func testLiveQueryForPendingIDSpecificCursor() {
        let expectation = XCTestExpectation(description: "Observes number of documents in live query")
        let collectionName: String = UUID().uuidString
        let collection: DittoCollection = ditto.store[collectionName]

        let insertedId = try! collection.insert([
            "name": "Honda",
            "mileage": 1234
        ])

        collection
            .findByID(insertedId)
            .rx
            .liveQuery
            .subscribe(onNext: { (doc, _) in
                guard let doc = doc else {
                    expectation.isInverted = true
                    expectation.fulfill()
                    return
                }
                XCTAssert(doc["name"].stringValue == "Honda")
                XCTAssert(doc["mileage"].intValue == 1234)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 10.0)
        disposeBag = DisposeBag()
    }
    
}
