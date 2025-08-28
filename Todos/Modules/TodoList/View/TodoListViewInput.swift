import UIKit
import TinyConstraints

protocol TodoListViewInput: AnyObject {
    var navController: UINavigationController? { get }
    func reloadRow(at id: Int)
    func reloadTableView()
    func setupToolBarTitle(_ title: String)
}
