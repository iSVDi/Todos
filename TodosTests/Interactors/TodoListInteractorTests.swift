import XCTest
@testable import Todos

final class TodoListInteractorTests: XCTestCase {
    func testCreateTodoNotifiesPresenter() {
        let presenter = MockPresenter()
        let interactor = TodoListInteractor(presenter: presenter)
        let exp = expectation(description: "didCreateTodo")
        presenter.onCreated = {
            exp.fulfill()
        }
        interactor.createTodo()
        wait(for: [exp], timeout: 2)
    }
}

fileprivate final class MockPresenter: TodoListInteractorOutput {
    var onCreated: (() -> Void)?
    var onFetched: (([TodoDomain]) -> Void)?
    func didCreateTodo() { onCreated?() }
    func didFetchTodos(_ todos: [TodoDomain]) { onFetched?(todos) }
}
