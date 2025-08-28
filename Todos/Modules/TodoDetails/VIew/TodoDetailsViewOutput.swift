import Foundation

protocol TodoDetailsViewOutput: AnyObject {
    func handleViewDidLoad()
    func handleViewWillDissapepar(_ todoDetails: TodoDetails)
    
}
