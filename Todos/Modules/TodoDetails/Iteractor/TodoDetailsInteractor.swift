import Foundation
final class TodoDetailsInteractor: TodoDetailsInteractorInput {
    private weak var presenter: TodoDetailsInteractorOutput?
    private let dataManager = DataManager()
    private var todoModel: TodoModel?
    private let queue = OperationQueue()
    
    init(presenter: TodoDetailsInteractorOutput) {
        self.presenter = presenter
    }
    
    func fetchTodo(by id: Int32) {
        performOnBackgroundThread { [weak self] in
            guard let self, let todoModel = dataManager.fetchTodoModel(by: id) else { return }
            self.todoModel = todoModel
            OperationQueue.main.addOperation { [weak self] in
                self?.presenter?.didFetchTodo(todoModel.mapToTodo())
            }
            
        }
    }
    
    func fetchLastCreatedTodo() {
        performOnBackgroundThread { [weak self] in
            guard let self, let todoModel = dataManager.fetchLastCreatedTodo() else { return }
            self.todoModel = todoModel
            presenter?.didFetchTodo(todoModel.mapToTodo())
        }
    }
    
    func handleViewWillDissapepar(_ todoDetails: TodoDetails) {
        performOnBackgroundThread { [weak self] in
            guard let self, let todoModel, checkShouldUpdateTodo(todoDetails: todoDetails) else { return }
            todoModel.title = todoDetails.title
            todoModel.details = todoDetails.description
            dataManager.save()
        }
    }
}

//MARK: - TodoDetailsInteractor

private extension TodoDetailsInteractor {
    func checkShouldUpdateTodo(todoDetails: TodoDetails) -> Bool {
        guard let todoModel else { return false }
        return todoModel.title != todoDetails.title || todoModel.details != todoDetails.description
    }
    
    func performOnBackgroundThread(_ block: @escaping () -> Void) {
        let block = BlockOperation(block: block)
        queue.addOperation(block)
    }
}
