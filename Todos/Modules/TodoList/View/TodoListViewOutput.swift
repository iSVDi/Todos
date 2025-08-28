import Foundation

protocol TodoListViewOutput: AnyObject {
    var numberOfRows: Int { get }
    
    func handleViewWillAppear()
    func getTodo(by cellId: Int) -> TodoDomain
    func didTapCell(cellId: Int)
    func handleCreateTodoTap()
    func editTodo(cellId: Int)
    func deleteTodo(cellId: Int)
    func searchBy(text: String)
}
