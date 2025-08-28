import Foundation
import Moya

final class TodoListInteractor: TodoListInteractorInput {
    private weak var presenter: TodoListInteractorOutput?
    
    private let userDataService = UserDataService()
    private let provider = MoyaProvider<TodoDataFetcher>()
    private let dataManager = DataManager()
    private let logService = LogService()
    private let queue = OperationQueue()
    
    init(presenter: TodoListInteractorOutput) {
        self.presenter = presenter
    }
    
    func createTodo() {
        performOnBackgroundThread { [weak self] in
            guard let self else { return }
            dataManager.createTodoModel()
            dataManager.save()
            OperationQueue.main.addOperation { [weak self] in
                self?.presenter?.didCreateTodo()
            }
        }
    }
    
    func fetchAllTodos() {
        performOnBackgroundThread { [weak self] in
            guard let self else { return }
            guard userDataService.isFirstLaunch else {
                logService.displayInfo("Loading todos from CoreData")
                retrieveTodos()
                return
            }
            logService.displayInfo("Loading todos via API")
            fetchTodos()
            userDataService.isFirstLaunch = false
        }
    }
    
    func toggleTodoCompletion(id: Int32) {
        performOnBackgroundThread { [weak self] in
            guard let self else { return }
            let todo = dataManager.fetchTodoModel(by: id)
            todo?.isCompleted.toggle()
            dataManager.save()
        }
    }
    
    func deleteTodo(id: Int32) {
        performOnBackgroundThread { [weak self] in
            guard let self else { return }
            dataManager.deleteTodo(id: id)
            retrieveTodos()
        }
    }
    
}

//MARK: - TodoListInteractor

private extension TodoListInteractor {
    func fetchTodos() {
        provider.request(.getAllTodos) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let todoBunch = try JSONDecoder().decode(TodoBunchData.self, from: response.data)
                    saveTodos(todoBunch.todos)
                    retrieveTodos()
                } catch {
                    logService.displayError("Error while request all todos: \(error)")
                }
                
            case .failure(let errror):
                logService.displayError("Bad getAllTodos request \(errror) ")
            }
        }
        
    }
    
    func retrieveTodos() {
        let todos = dataManager.fetchAllTodoModel().map {
            TodoDomain(
                id: $0.id,
                title: $0.title,
                description: $0.details,
                isCompleted: $0.isCompleted,
                creationDate: $0.creationDate
            )
        }
        OperationQueue.main.addOperation { [weak self] in
            self?.presenter?.didFetchTodos(todos)
        }
    }
    
    func saveTodos(_ todos: [TodoData]) {
        todos.forEach{ todo in
            let todoModel = self.dataManager.createTodoModel()
            todoModel.id = todo.id
            todoModel.details = todo.description
            todoModel.title = self.getTitleFromDescription(todo.description)
            todoModel.isCompleted = todo.isCompleted
            todoModel.creationDate = .now
        }
        dataManager.save()
    }
    
    func getTitleFromDescription(_ description: String) -> String {
        let separatedTitle = description.split(separator: " ")
        switch separatedTitle.count {
        case 3...:
            return separatedTitle[0...2].joined(separator: " ")
        case 2...:
            return separatedTitle[0...1].joined(separator: " ")
        default:
            return "Untitled"
        }
    }
    
    func performOnBackgroundThread(_ block: @escaping () -> Void) {
        let block = BlockOperation(block: block)
        queue.addOperation(block)
    }
}
