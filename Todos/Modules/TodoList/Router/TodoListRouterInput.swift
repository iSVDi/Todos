import Foundation
import UIKit

protocol TodoListRouterInput: AnyObject {
    func pushToTodoDetails(from navController: UINavigationController?, with state: TodoState)
}
