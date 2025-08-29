import XCTest
@testable import Todos

final class TodoDetailsPresenterTests: XCTestCase {
    private var presenter: TodoDetailsPresenter!
    private var view: MockView!
    private var interactor: MockInteractor!

    override func setUp() {
        super.setUp()
        view = MockView()
        interactor = MockInteractor()
        presenter = TodoDetailsPresenter(todoState: .create)
        presenter.view = view
        presenter.interactor = interactor
    }

    func testHandleViewDidLoadCreateCallsFetchLast() {
        let exp = expectation(description: "fetchLast")
        interactor.onFetchLast = {
            exp.fulfill()
        }
        presenter.handleViewDidLoad()
        wait(for: [exp], timeout: 1)
    }

    func testHandleViewDidLoadEditCallsFetchById() {
        let interactor = MockInteractor()
        let p = TodoDetailsPresenter(todoState: .edit(99))
        p.view = view
        p.interactor = interactor
        let exp = expectation(description: "fetchById")
        interactor.onFetchById = { id in
            XCTAssertEqual(id, 99)
            exp.fulfill()
        }
        p.handleViewDidLoad()
        wait(for: [exp], timeout: 1)
    }

    func testHandleViewWillDisappearForwardsDetails() {
        let exp = expectation(description: "willDisappear")
        interactor.onWillDisappear = { d in
            XCTAssertEqual(d.title, "T")
            XCTAssertEqual(d.description, "D")
            exp.fulfill()
        }
        let details = TodoDetails(title: "T", description: "D")
        presenter.handleViewWillDissapepar(details)
        wait(for: [exp], timeout: 1)
    }

    func testDidFetchTodoUpdatesView() {
        let exp = expectation(description: "setupData")
        view.onSetup = { todo in
            XCTAssertEqual(todo.id, 1)
            XCTAssertEqual(todo.title, "A")
            exp.fulfill()
        }
        let todo = TodoDomain(id: 1,title: "A",description: "d",isCompleted: false,creationDate: .now)
        presenter.didFetchTodo(todo)
        wait(for: [exp], timeout: 1)
    }
}

//MARK: - Mock data types

private final class MockView: TodoDetailsViewInput {
    var onSetup: ((TodoDomain) -> Void)?
    func setupData(todo: TodoDomain) { onSetup?(todo) }
}

private final class MockInteractor: TodoDetailsInteractorInput {
    var onWillDisappear: ((TodoDetails) -> Void)?
    var onFetchLast: (() -> Void)?
    var onFetchById: ((Int32) -> Void)?
    func handleViewWillDissapepar(_ todoDetails: TodoDetails) { onWillDisappear?(todoDetails) }
    func fetchLastCreatedTodo() { onFetchLast?() }
    func fetchTodo(by id: Int32) { onFetchById?(id) }
}
