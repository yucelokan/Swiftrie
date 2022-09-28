import XCTest
@testable import Swiftrie

final class SwiftrieTests: XCTestCase {
    
    func testInitializing() {
        let count = 100
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        let items: [SwiftrieTestModel] = trie.getAllItems()
        XCTAssertEqual(items.count, models.count)
        XCTAssertEqual(items.count, count)
    }
    
    func testEmptyInitializing() {
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: [])
        let items: [SwiftrieTestModel] = trie.getAllItems()
        XCTAssertEqual(items.count, 0)
        XCTAssertEqual(items.count, 0)
    }
    
    func testOrdering() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        let items: [SwiftrieTestModel] = trie.getAllItems()
        
        for index in 0..<count {
            XCTAssertEqual(items[index].name, models[index].name)
        }
    }
    
    func testInserting() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        var items: [SwiftrieTestModel] = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count, "counts are not equal")
        XCTAssertEqual(items.count, count, "counts are not equal")
        
        let itemZero = SwiftrieTestModel(name: "item", id: 0)
        trie.insertItem(itemZero)
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count + 1, "counts are not equal")
        XCTAssertEqual(items.count, count + 1, "counts are not equal")
        
        XCTAssertEqual(
            itemZero.name, items.first?.name, "position is wrong (item should be added to head of list)"
        )
        
        let itemSix = SwiftrieTestModel(name: "item 6", id: 6)
        trie.insertItem(itemSix)
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count + 2, "counts are not equal")
        XCTAssertEqual(items.count, count + 2, "counts are not equal")
        
        XCTAssertEqual(itemSix.name, items.last?.name, "position is wrong (item 6 added to end of list)")
    }
    
    func testRemoving() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        var items: [SwiftrieTestModel] = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count, "counts are not equal")
        XCTAssertEqual(items.count, count, "counts are not equal")
        
        let itemThree = models[2]
        trie.removeItem(itemThree)
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count - 1, "counts are not equal")
        XCTAssertEqual(items.count, count - 1, "counts are not equal")
        
        XCTAssertFalse(items.contains(where: {$0.name == itemThree.name}), "removed item is still in the list")
        
        trie.insertItem(itemThree) // insert it again
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, models.count, "counts are not equal")
        XCTAssertEqual(items.count, count, "counts are not equal")
        
        XCTAssertEqual(itemThree.name, items[2].name, "position is wrong (item 3 should be added at index 2)")
        
        for index in 0..<count {
            XCTAssertEqual(items[index].name, models[index].name)
        }
    }
    
    func testFailFinding() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        var findedResult: [SwiftrieTestModel] = [.init(name: "addedAItem", id: 0)]
        
        let promise = expectation(description: "response-handler-fail-finding")
        trie.findItems(prefix: "wrong-prefix", throttle: 0, type: SwiftrieTestModel.self) { result in
            findedResult = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
        
        XCTAssertTrue(findedResult.count == 0)
    }
    
    func testSuccessAllFinding() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        var findedResult: [SwiftrieTestModel] = []
        
        let promise = expectation(description: "response-handler-success-all-finding")
        trie.findItems(prefix: "i", throttle: 0, type: SwiftrieTestModel.self) { result in
            findedResult = result
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 2)
        
        XCTAssertTrue(findedResult.count == 5)
    }
    
    func testSuccessOneFinding() {
        let count = 5
        let models = TestModelCreator.get(count: count).models
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: models)
        
        var findedResult: [SwiftrieTestModel] = []
        
        let promise = expectation(description: "response-handler-success-one-finding")
        trie.findItems(prefix: "item 1", throttle: 0, type: SwiftrieTestModel.self) { result in
            findedResult = result
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 2)
        
        XCTAssertTrue(findedResult.count == 1)
        let items = findedResult.filter({$0.name.hasPrefix("item")})
        XCTAssertEqual(items.count, findedResult.count)
    }
    
    // testing same word and different object
    func testDuplicationItems() {
        let item0 = SwiftrieTestModel(name: "same name", id: 0)
        let item1 = SwiftrieTestModel(name: "same name", id: 1)
        
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: [item0, item1])
        
        var items: [SwiftrieTestModel] = trie.getAllItems()
        XCTAssertEqual(items.count, 2)
        
        // remove it
        trie.removeItem(item0)
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, 1)
        
        let hasContainItem2 = items[0].id == 1
        
        XCTAssertTrue(hasContainItem2)
        
        // insert it
        
        trie.insertItem(item0)
        
        items = trie.getAllItems()
        
        XCTAssertEqual(items.count, 2)
    }
    
    // testing inserting same
    func testInsertingSameItems() {
        let item0 = SwiftrieTestModel(name: "same name", id: 0)
        
        let trie: SwiftrieAccessibleLogic = Swiftrie(swiftriables: [item0])
        
        trie.insertItem(item0)
        
        let items: [SwiftrieTestModel] = trie.getAllItems()
        
        XCTAssertEqual(items.count, 1)
    }
}
