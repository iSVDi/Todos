import Foundation

final class TodoListPresenter {
    private weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput?
    var router: TodoListRouterInput?
    
    private var todos: [TodoDomain] = []
    private var searchQuery: String = ""
    
    init(view: TodoListViewInput) {
        self.view = view
    }
    
}

//MARK: - TodoListViewToOutput

extension TodoListPresenter: TodoListViewOutput {
    var numberOfRows: Int {
        return getFilteredTodos().count
    }
    
    func handleViewWillAppear() {
        interactor?.fetchAllTodos()
    }
    
    func getTodo(by cellId: Int) -> TodoDomain {
        return getFilteredTodos()[cellId]
    }
    
    func didTapCell(cellId: Int) {
        let filteredTodos = getFilteredTodos()
        let id = filteredTodos[cellId].id
        guard let arrIndex = todos.firstIndex(where: { $0.id == id}) else { return }
        todos[arrIndex].isCompleted.toggle()
        interactor?.toggleTodoCompletion(id: id)
        updateToolbarTitle()
        view?.reloadRow(at: cellId)
    }
    
    func handleCreateTodoTap() {
        interactor?.createTodo()
    }
    
    func editTodo(cellId: Int) {
        let todoId = getFilteredTodos()[cellId].id
        router?.pushToTodoDetails(from: view?.navController, with: .edit(todoId))
    }
    
    func deleteTodo(cellId: Int) {
        let id = getFilteredTodos()[cellId].id
        interactor?.deleteTodo(id: id)
    }
    
    func searchBy(text: String) {
        searchQuery = text.lowercased()
        view?.reloadTableView()
    }
}


// MARK: - TodoListInterceptorToPresenter

extension TodoListPresenter: TodoListInteractorOutput {
    func didCreateTodo() {
        router?.pushToTodoDetails(from: view?.navController, with: .create)
    }
    
    func didFetchTodos(_ todos: [TodoDomain]) {
        self.todos = todos
        self.todos.sort(by: { $0.id > $1.id})
        view?.reloadTableView()
        updateToolbarTitle()
    }
    
    func getUncomplitedTodoCount() -> Int {
        return getFilteredTodos().filter{ !$0.isCompleted }.count
    }
    
}

//MARK: - Helpers

private extension TodoListPresenter {
    func getFilteredTodos() -> [TodoDomain] {
        guard !searchQuery.isEmpty else { return todos }
        return todos.filter {
            $0.description.lowercased().contains(searchQuery) || $0.description.lowercased().contains(searchQuery)
        }
    }
    
    func updateToolbarTitle() {
        let count = getFilteredTodos().filter({ !$0.isCompleted }).count
        let title = count > 0 ? "In progress: \(count)" : "All Todos completed"
        view?.setupToolBarTitle(title)
    }
}
