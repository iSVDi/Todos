import Foundation
import Moya

protocol TodoListInteractorInput: AnyObject {
    func fetchAllTodos()
    func createTodo()
    func toggleTodoCompletion(id: Int32)
    func deleteTodo(id: Int32)
}
