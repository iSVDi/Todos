import XCTest
@testable import Todos

final class TodoListPresenterTests: XCTestCase {
    private var presenter: TodoListPresenter!
    private var view: MockView!
    private var interactor: MockInteractor!
    private var router: MockRouter!

    override func setUp() {
        super.setUp()
        view = MockView()
        interactor = MockInteractor()
        router = MockRouter()
        presenter = TodoListPresenter(view: view)
        presenter.interactor = interactor
        presenter.router = router
    }

    func testHandleViewWillAppearTriggersFetch() {
        let exp = expectation(description: "fetchAllTodos")
        interactor.onFetchAll = { exp.fulfill() }
        presenter.handleViewWillAppear()
        wait(for: [exp], timeout: 1)
    }

    func testDidFetchTodosSortsDescAndReloads() {
        let exp = expectation(description: "reload")
        view.onReload = { exp.fulfill() }
        presenter.didFetchTodos([
            TodoDomain(id: 1, title: "A", description: "d", isCompleted: false, creationDate: .now),
            TodoDomain(id: 3, title: "C", description: "d", isCompleted: false, creationDate: .now),
            TodoDomain(id: 2, title: "B", description: "d", isCompleted: false, creationDate: .now)
        ])
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(presenter.numberOfRows, 3)
        XCTAssertEqual(presenter.getTodo(by: 0).id, 3)
        XCTAssertEqual(presenter.getTodo(by: 1).id, 2)
        XCTAssertEqual(presenter.getTodo(by: 2).id, 1)
    }

    func testDidTapCellTogglesAndReloadsRow() {
        let reload = expectation(description: "reloadRow")
        view.onReloadRow = { index in
            XCTAssertEqual(index, 0)
            reload.fulfill()
        }
        let toggled = expectation(description: "toggle")
        interactor.onToggle = { id in
            XCTAssertEqual(id, 10)
            toggled.fulfill()
        }
        let todo = TodoDomain(id: 10, title: "T", description: "d", isCompleted: false, creationDate: .now)
        presenter.didFetchTodos([todo])
        presenter.didTapCell(cellId: 0)
        wait(for: [reload, toggled], timeout: 1)
    }

    func testCreateTapCallsInteractor() {
        let exp = expectation(description: "create")
        interactor.onCreate = {
            exp.fulfill()
        }
        presenter.handleCreateTodoTap()
        wait(for: [exp], timeout: 1)
    }

    func testEditRoutesToDetails() {
        let exp = expectation(description: "route")
        let todo = TodoDomain(id: 2, title: "T", description: "d", isCompleted: false, creationDate: .now)
        presenter.didFetchTodos([todo])
        router.onPush = { _, state in
            if case .edit(let id) = state {
                XCTAssertEqual(id, 2)
                exp.fulfill()
            }
        }
        presenter.editTodo(cellId: 0)
        wait(for: [exp], timeout: 1)
    }

    func testDeleteCallsInteractor() {
        let exp = expectation(description: "delete")
        let todo = TodoDomain(id: 7, title: "T", description: "d", isCompleted: false, creationDate: .now)
        presenter.didFetchTodos([todo])
        interactor.onDelete = { id in
            XCTAssertEqual(id, 7)
            exp.fulfill()
        }
        presenter.deleteTodo(cellId: 0)
        wait(for: [exp], timeout: 1)
    }
}

//MARK: - Mock data types

private final class MockView: TodoListViewInput {
    var navController: UINavigationController?
    var onReloadRow: ((Int) -> Void)?
    var onReload: (() -> Void)?
    var onTitle: ((String) -> Void)?
    func reloadRow(at id: Int) { onReloadRow?(id) }
    func reloadTableView() { onReload?() }
    func setupToolBarTitle(_ title: String) { onTitle?(title) }
}

private final class MockInteractor: TodoListInteractorInput {
    var onFetchAll: (() -> Void)?
    var onCreate: (() -> Void)?
    var onToggle: ((Int32) -> Void)?
    var onDelete: ((Int32) -> Void)?
    func fetchAllTodos() { onFetchAll?() }
    func createTodo() { onCreate?() }
    func toggleTodoCompletion(id: Int32) { onToggle?(id) }
    func deleteTodo(id: Int32) { onDelete?(id) }
}

private final class MockRouter: TodoListRouterInput {
    var onPush: ((UINavigationController?, TodoState) -> Void)?
    func pushToTodoDetails(from navController: UINavigationController?, with state: TodoState) { onPush?(navController, state) }
}
