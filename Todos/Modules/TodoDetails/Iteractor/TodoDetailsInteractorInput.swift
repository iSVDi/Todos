import Foundation

protocol TodoDetailsInteractorInput: AnyObject {
    func handleViewWillDissapepar(_ todoDetails: TodoDetails) 
    func fetchLastCreatedTodo()
    func fetchTodo(by id: Int32)
}
