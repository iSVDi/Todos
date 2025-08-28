import Foundation
import UIKit

protocol TodoDetailsViewInput: AnyObject {
    func setupData(todo: TodoDomain)
}
