final class TodoDetailsPresenter {
    weak var view: TodoDetailsViewInput?
    var interactor: TodoDetailsInteractorInput?
    private let todoState: TodoState
    
    init(todoState: TodoState) {
        self.todoState = todoState
    }
    
}

//MARK: - TodoDetailsViewOutput

extension TodoDetailsPresenter: TodoDetailsViewOutput {
    func handleViewDidLoad() {
        switch todoState {
        case .edit(let todoId):
            interactor?.fetchTodo(by: todoId)
        case .create:
            interactor?.fetchLastCreatedTodo()
        }
    }
    
    func handleViewWillDissapepar(_ todoDetails: TodoDetails) {
        interactor?.handleViewWillDissapepar(todoDetails)
    }
    
}

//MARK: - TodoDetailsInteractorOutput

extension TodoDetailsPresenter: TodoDetailsInteractorOutput {
    func didFetchTodo(_ todoModel: TodoDomain) {
        view?.setupData(todo: todoModel)
    }
    
}
