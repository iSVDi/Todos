import Foundation

extension Date {
    func getFormattedDate(_ format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
