import Foundation
import Moya

struct TodoBunchData: Decodable {
    let todos: [TodoData]
}

struct TodoData: Decodable {
    let id: Int32
    let description: String
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "todo"
        case isCompleted = "completed"
    }
}
