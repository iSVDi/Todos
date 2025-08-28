import Foundation
import CoreData

extension TodoModel: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoModel> {
        return NSFetchRequest<TodoModel>(entityName: "TodoModel")
    }

    @NSManaged public var creationDate: Date
    @NSManaged public var details: String
    @NSManaged public var id: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        title = "Untitled"
        isCompleted = false
        creationDate = .now
    }
}
