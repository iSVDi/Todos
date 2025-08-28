import Foundation
import UIKit

final class TodoListAssembly {
    static func getModule() -> UINavigationController {
        let viewController = TodoListViewController()
        let presenter = TodoListPresenter(view: viewController)
        let interactor = TodoListInteractor(presenter: presenter)
        let router = TodoListRouter()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
        let navController = UINavigationController(rootViewController: viewController)
        return navController
    }
    
}
