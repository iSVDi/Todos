import XCTest
@testable import Todos

final class TodoDetailsInteractorTests: XCTestCase {
    func testFetchLastCreatedTodoNotifiesPresenter() {
        let presenter = MockPresenter()
        let interactor = TodoDetailsInteractor(presenter: presenter)
        let exp = expectation(description: "didFetchTodo")
        presenter.onFetched = { _ in
            exp.fulfill()
        }
        interactor.fetchLastCreatedTodo()
        wait(for: [exp], timeout: 2)
    }
}

fileprivate final class MockPresenter: TodoDetailsInteractorOutput {
    var onFetched: ((TodoDomain) -> Void)?
    func didFetchTodo(_ todo: TodoDomain) { onFetched?(todo) }
}
