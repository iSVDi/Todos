import Foundation

struct TodoDomain: Decodable {
    let id: Int32
    let title: String
    let description: String
    var isCompleted: Bool
    let creationDate: Date
}
