import Foundation

extension TodoModel {
    func mapToTodo() -> TodoDomain {
        TodoDomain(
            id: id,
            title: title,
            description: details,
            isCompleted: isCompleted,
            creationDate: creationDate
        )
    }
}
