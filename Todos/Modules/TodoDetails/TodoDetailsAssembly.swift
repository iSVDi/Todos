import UIKit

final class TodoDetailsAssembly {
    static func getModule(with state: TodoState) -> UIViewController {
        let viewController = TodoDetailsViewController()
        let presenter = TodoDetailsPresenter(todoState: state)
        let interactor = TodoDetailsInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        
        return viewController
    }
    
}
