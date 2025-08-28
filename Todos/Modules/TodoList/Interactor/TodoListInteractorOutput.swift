import Foundation

protocol TodoListInteractorOutput: AnyObject {
    func didCreateTodo()
    func didFetchTodos(_ todos: [TodoDomain])
}
