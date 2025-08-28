import Foundation
import UIKit

final class TodoListRouter: TodoListRouterInput {
    func pushToTodoDetails(from navController: UINavigationController?, with state: TodoState) {
        let vc = TodoDetailsAssembly.getModule(with: state)
        navController?.pushViewController(vc, animated: true)
    }
    
}
