import Foundation

protocol TodoDetailsInteractorOutput: AnyObject {
    func didFetchTodo(_ todo: TodoDomain)
}
