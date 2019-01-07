// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest

class FriendListDataSourceTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Antidote/objcTox should be refactored to protocol oriented architecture, then testing will become possible :-)

    // func testPerformFetch() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     // calling some method requiring both requests and friends controller
    //     _ = dataSource.numberOfSections()

    //     XCTAssertTrue(requests.didPerformFetch)
    //     XCTAssertTrue(friends.didPerformFetch)
    // }

    // func testReset() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     dataSource.reset()

    //     XCTAssertTrue(requests.didReset)
    //     XCTAssertTrue(friends.didReset)
    // }

    // func testNumberOfSections_NoRequests_NoFriends() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 1)
    // }

    // func testNumberOfSections_NoRequests_OneFriendSection() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [[ NSObject() ]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 1)
    // }

    // func testNumberOfSections_NoRequests_MultipleFriendSection() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [
    //         [NSObject()],
    //         [NSObject()],
    //         [NSObject()],
    //     ])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 3)
    // }

    // func testNumberOfSections_OneRequest_NoFriends() {
    //     let requests = MockedFetchedResultsController(objects: [[ NSObject() ]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 2)
    // }

    // func testNumberOfSections_MultipleRequest_NoFriends() {
    //     let requests = MockedFetchedResultsController(objects: [[
    //         NSObject(),
    //         NSObject(),
    //         NSObject(),
    //     ]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 2)
    // }

    // func testNumberOfSections_MultipleRequest_MultipleFriends() {
    //     let requests = MockedFetchedResultsController(objects: [[
    //         NSObject(),
    //         NSObject(),
    //         NSObject(),
    //     ]])
    //     let friends = MockedFetchedResultsController(objects: [
    //         [NSObject()],
    //         [NSObject()],
    //         [NSObject()],
    //     ])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfSections(), 4)
    // }

    // func testNumberOfRows_Empty() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [[]])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfRowsInSection(0), 0)
    // }

    // func testNumberOfRows_NoRequest_Friends() {
    //     let requests = MockedFetchedResultsController(objects: [[]])
    //     let friends = MockedFetchedResultsController(objects: [
    //         [NSObject()],
    //         [NSObject(), NSObject()],
    //         [NSObject(), NSObject(), NSObject()],
    //     ])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfRowsInSection(0), 1)
    //     XCTAssertEqual(dataSource.numberOfRowsInSection(1), 2)
    //     XCTAssertEqual(dataSource.numberOfRowsInSection(2), 3)
    // }

    // func testNumberOfRows_Requests_Friends() {
    //     let requests = MockedFetchedResultsController(objects: [[
    //         NSObject(),
    //         NSObject(),
    //         NSObject(),
    //         NSObject(),
    //     ]])
    //     let friends = MockedFetchedResultsController(objects: [
    //         [NSObject()],
    //         [NSObject(), NSObject()],
    //         [NSObject(), NSObject(), NSObject()],
    //     ])

    //     let dataSource = FriendListDataSource(requestsController: requests, friendsController: friends)

    //     XCTAssertEqual(dataSource.numberOfRowsInSection(0), 4)
    //     XCTAssertEqual(dataSource.numberOfRowsInSection(1), 1)
    //     XCTAssertEqual(dataSource.numberOfRowsInSection(2), 2)
    //     XCTAssertEqual(dataSource.numberOfRowsInSection(3), 3)
    // }
}
